require_relative '../rede_brasil_plugin'


class RedeBrasilPlugin::PidsLoader < MyProfileController

  helper CustomFieldsHelper
  helper :profile
    # require 'csv'
    # require 'time'
    # CSV::Converters[:datePt2Date] = lambda{|s|
    #   begin
    #     Time.parse(s).to_date
    #   rescue ArgumentError
    #     s
    #   end
    # }

    @transformed = __dir__ + '/../../data/transformed.csv'
    @log = __dir__ + '/../../import.log'


    @h ={
    "custom_values"=>{
      "Micros para Doação Solicitado"=>{"value"=>696969, "public"=>"0"},
      "Data"=>{"value"=>"2016-12-30", "public"=>"0"}
      }
    }

    def self.reset_custom_values
      @h ={
        "custom_values"=>{}
      }
    end

    def self.append_values(r)
      r.each do |k,v|
        @h["custom_values"][k]={"value"=>v, "public"=>"1"}
      end
    end

    def self.date_format(brazilian_date)
      dt = Date.strptime(brazilian_date, '%m/%d/%y')
      # dt.year + '/' + date.month + '/' + date.day
      "2001" + '/' + date.month + '/' + date.day

    end

    @no_name=0
    def self.fix_data(r)
      unless r['Nome'].present?
        r['Nome'] = "Sem nome #{@no_name}"
      end
      r['Uf'] = 'NI' unless r['Uf'].present?
      r['Tipo telecentro'] = 'NI' unless r['Tipo telecentro'].present?
      r['Data'] = date_format(r['Data'])
      r['Data da Adesão'] = date_format(r['Data da Adesão'])
      return r
    end


    def log_write
      File.open(@transformed = __dir__ + '/../../import.log', 'w') { |file| file.write("your text") }
    end

    def self.load
      Community.destroy_all
      line = 0
      FileUtils.rm_rf @log


      CSV.foreach(@transformed, headers: true) do |r| # Iterate over each row of our CSV file
        line += 1
        next if line < 8
        r=fix_data(r)
        reset_custom_values
        r.delete('name')
        ap r
        next unless r['Nome'].present?
        c = Community.new
        c.name = r['Nome']
        c.save!
        ap r.to_hash
        append_values(r.to_hash)
        ap @h
        File.open(@log, 'a+') {|f| f.write(@h.inspect) }
        result=c.update!(@h, without_protection: true)
        ap result
        break if line == 30
      end
    end
  end
