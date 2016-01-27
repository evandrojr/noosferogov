require_relative '../rede_brasil_plugin'

class RedeBrasilPlugin::CustomFieldsFiller

    require 'csv'
    require 'time'
    require 'yaml'

    @transformed = __dir__ + '/../../data/transformed.csv'

    def self.destroy
      ActiveRecord::Base.connection.execute("TRUNCATE custom_fields RESTART IDENTITY")
    end

    def self.create
      @e = Environment.default
      line = 1
      s = []
      CSV.foreach(@transformed) do |r|
        s << r
        line += 1
        break if line == 9
      end
      s = s.transpose
      line = -1
      dont_create = %w{Nome UF Município Município Bairro	Endereço CEP}
      dont_create = %w{Nome}
      s.each do |r|
        line+=1
        name = r[0]
        next if line == 0 || dont_create.include?(name)
        if r[4].present?
          extras = YAML.load(r[4])
        else
          extras = nil
        end
        default_value = "" if default_value.nil?
        c = CustomField.create(:name => name, :format => r[1], :default_value => default_value, :customized_type => r[3], :extras => extras, :active => r[5], :required => r[6], :signup => r[7], :environment => @e)
      end
    end
  end
