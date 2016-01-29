require_relative '../rede_brasil_plugin'

class RedeBrasilPlugin::CustomFieldsFiller

    require 'csv'
    require 'time'
    require 'yaml'

    @transformed = __dir__ + '/../../data/transformed.csv'
    @e = Environment.default

    def self.destroy
      ActiveRecord::Base.connection.execute("TRUNCATE custom_fields RESTART IDENTITY")
    end

    def self.load_domains
      return unless RedeBrasilPlugin::Store.data.empty? or RedeBrasilPlugin::Store.data[:domains].empty?
      line = 1
      meta_data = []
      CSV.foreach(@transformed) do |row|
        meta_data << row
        line += 1
        break if line == RedeBrasilPlugin.csv_first_data_row
      end
      meta_data = meta_data.transpose
      line = -1
      # dont_create = %w{Nome UF Município Município Bairro	Endereço CEP}
      dont_create = %w{Nome}
      RedeBrasilPlugin::Store.data[:domains] = {}
      meta_data.each do |row|
        line+=1
        name = row[0]
        next if line == 0 || dont_create.include?(name)
        if row[4].present?
          extras = YAML.load(row[4])
          RedeBrasilPlugin::Store.data[:domains][name]=extras
        end
      end
      RedeBrasilPlugin::Store.data
    end

    def self.fill_data
      line = 1
      meta_data = []
      CSV.foreach(@transformed) do |row|
        meta_data << row
        line += 1
        break if line == RedeBrasilPlugin.csv_first_data_row
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
        @customized_type=row[3]
        CustomField.create(:name => name, :format => row[1], :default_value => default_value, :customized_type => @customized_type, :extras => extras, :active => row[5], :required => row[6], :signup => row[7], :environment => @e)
      end
      CustomField.create(:name => "is_pid?", :format => checkbox, :default_value => true, :customized_type => @customized_type, :extras => nil, :active => false, :required => false, :signup => false, :environment => @e)
      CustomField.create(:name => "batch_loaded?", :format => checkbox, :default_value => true, :customized_type => @customized_type, :extras => nil, :active => false, :required => false, :signup => false, :environment => @e)
    end
  end
