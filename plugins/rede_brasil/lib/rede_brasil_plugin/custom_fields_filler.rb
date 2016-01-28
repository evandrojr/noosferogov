require_relative '../rede_brasil_plugin'

class RedeBrasilPlugin::CustomFieldsFiller

    require 'csv'
    require 'time'
    require 'yaml'

    @transformed = __dir__ + '/../../data/transformed.csv'

    def self.destroy
      ActiveRecord::Base.connection.execute("TRUNCATE custom_fields RESTART IDENTITY")
    end

    def self.fill_data
      @e = Environment.default
      line = 1
      meta_data = []
      CSV.foreach(@transformed) do |row|
        meta_data << row
        line += 1
        break if line == 9
      end
      meta_data = meta_data.transpose
      line = -1
      # dont_create = %w{Nome UF Município Município Bairro	Endereço CEP}
      dont_create = %w{Nome}
      meta_data.each do |row|
        line+=1
        name = row[0]
        next if line == 0 || dont_create.include?(name)
        if row[4].present?
          extras = YAML.load(row[4])
        else
          extras = nil
        end
        default_value = "" if default_value.nil?
        cf = CustomField.create(:name => name, :format => row[1], :default_value => default_value, :customized_type => row[3], :extras => extras, :active => row[5], :required => row[6], :signup => row[7], :environment => @e)
      end
    end
  end
