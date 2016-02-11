require_relative '../rede_brasil_plugin'
require_relative 'better_csv_row'

class RedeBrasilPlugin::PidsLoader < MyProfileController

  helper CustomFieldsHelper
  helper :profile

  @transformed = __dir__ + '/../../data/transformed.csv'
  @log = __dir__ + '/../../import.log'
  @custom_values_hash ={"custom_values"=>{}}

  def self.append_values(r)
    r.each do |k,v|
      @custom_values_hash["custom_values"][k]={"value"=>v, "public"=>true}
    end
  end

  def self.date_format(brazilian_date, line)
    return nil if brazilian_date.blank?

    begin
      dt = Date.strptime(brazilian_date, '%d/%m/%y')
    rescue
      log("Linha: #{line} - Data ou Data da Adesão inválida '#{brazilian_date}' usando data em branco")
      return nil
    end
    "#{dt.year}/#{dt.month}/#{dt.day}"
  end

  def self.check_domains(r, line)
    RedeBrasilPlugin::CustomFieldsFiller.load_domains
    RedeBrasilPlugin::Store.data[:domains].each do |k, v|
      unless v.include? r[k]
        log("Linha: #{line} - Campo #{k} com valor inválido '#{r[k]}'")
      end
    end
  end

  @no_name=0
  @same_name=0;
  def self.fix_data(r, line)
    check_domains(r, line)
    if Community.find_by_name(r['Nome']).class == Community
      log("Linha: #{line} - Pid com nome repetido #{r['Nome']} cadastrado como: #{r['Nome']} #{@same_name}")
      r['Nome'] = "#{r['Nome']} #{@same_name}"
      @same_name+=1
    end
    r['Nome']||=r['Nome da instituição recebedora da doação, conforme ofício']
    unless r['Nome'].present?
      log("Linha: #{line} - Pid sem nome")
      r['Nome'] = "Sem nome #{@no_name}"
      @no_name+=1
    end
    unless (r['Uf']).present?
      log("Linha: #{line} - Sem UF")
      r['Uf'] = 'NI'
    end
    unless (r['Tipo Telecentro']).present?
      log("Linha: #{line} - Sem Tipo Telecentro cadastrado: NI")
      r['Tipo telecentro'] = 'NI'
    end
    r['Data'] = date_format(r['Data'], line)
    r['Data da Adesão'] = date_format(r['Data da Adesão'], line)
    return r
  end

  @error_count=0
  def self.log(m)
    File.open(@log, 'a+') {|f| f.puts(m) }
    @error_count+=1
  end

  def self.load
    line = 0
    FileUtils.rm_rf @log

    CSV.foreach(@transformed, headers: true,
                :header_converters=> lambda do |f|
                  f.strip!
                  f.gsub(/\n/,'')
                 end,
                :converters=> [:sanitizer, :numeric]) do |row| # Iterate over each row of our CSV file
      line += 1
      next if line < RedeBrasilPlugin.csv_first_data_row
      better_csv_row = RedeBrasilPlugin::BetterCsvRow.new(row)
      better_csv_row = fix_data(better_csv_row, line)
      @custom_values_hash = {"custom_values"=>{}}
      better_csv_row.delete('name')
      exit "Error Pid sem nome" unless better_csv_row['Nome'].present?
      community = Community.new
      community.name = better_csv_row['Nome']
      if Community.find_by_identifier(community.identifier).class == Community
        community.identifier = "#{community.identifier}-#{rand(100..1000)}"
      end
      community.save!
      ap better_csv_row.to_hash
      append_values(better_csv_row.to_hash)
      @custom_values_hash["custom_values"]["is_pid?"]={"value"=>true, "public"=>true}
      @custom_values_hash["custom_values"]["batch_loaded?"]={"value"=>true, "public"=>true}
      ap @custom_values_hash
      result=community.update!(@custom_values_hash, without_protection: true)
      ap result
    end
  end
  end
