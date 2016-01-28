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
      begin
        dt = Date.strptime(brazilian_date, '%d/%m/%y')
      rescue
        log("Linha: #{line} - Data ou Data da Adesão inválida '#{brazilian_date}'")
        return '1999-01-01'
      end
      "#{dt.year}/#{dt.month}/#{dt.day}"
    end

    @no_name=0
    @same_name=0;
    def self.fix_data(r, line)

      if Community.find_by_name(r['Nome']).class == Community
        log("Linha: #{line} - Pid com nome repetido #{r['Nome']}")
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
        log("Linha: #{line} - Sem UF r: #{r.inspect}")
        r['Uf'] = 'NI'
      end
      unless (r['Tipo Telecentro']).present?
        log("Linha: #{line} - Sem Tipo Telecentro r: #{r.inspect}")
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
      Community.destroy_all
      line = 0
      FileUtils.rm_rf @log

      CSV.foreach(@transformed, headers: true,
                  :header_converters=> lambda do |f|
                    f.strip
                    f.gsub(/\n/,'')
                   end,
                  :converters=> lambda {|f| f ? f.strip : nil}) do |row| # Iterate over each row of our CSV file
        better_csv_row = RedeBrasilPlugin::BetterCsvRow.new(row)
        line += 1
        next if line < 8
        better_csv_row = fix_data(better_csv_row, line)
        @custom_values_hash = {"custom_values"=>{}}
        better_csv_row.delete('name')
        next unless better_csv_row['Nome'].present?
        community = Community.new
        community.name = better_csv_row['Nome']
        if Community.find_by_identifier(community.identifier).class == Community
          community.identifier = "#{community.identifier}-#{rand(100..1000)}"
        end
        community.save!
        ap better_csv_row.to_hash
        append_values(better_csv_row.to_hash)
        ap @custom_values_hash
        result=community.update!(@custom_values_hash, without_protection: true)
        ap result
        # break if line == 30
      end
    end
  end
