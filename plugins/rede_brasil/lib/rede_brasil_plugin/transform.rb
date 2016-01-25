require_relative '../rede_brasil_plugin'

class RedeBrasilPlugin::Transform

  require 'csv'
  require 'time'
  CSV::Converters[:datePt2Date] = lambda{|s|
    begin
      Time.parse(s).to_date
    rescue ArgumentError
      s
    end
  }

  @raw = __dir__ + '/../../data/data.csv'
  @transformed = __dir__ + '/../../data/transformed.csv'

  def self.status
    new_status_csv  = []
    line = 2
    CSV.foreach(@raw, headers: true) do |c| # Iterate over each row of our CSV file
      if line == 2
        #Add headers
        new_status_csv << c.to_hash.keys - (['Status Ativo'] + ['Status Inativo'] + ['Status Parcial'] + ['Status Sem Informação'])
      end
      sum = 0
      sum=(c['Status Ativo']).to_i + (c['Status Inativo']).to_i + (c['Status Parcial']).to_i + (c['Status Sem Informação']).to_i
      # puts "Linha: #{line} soma: #{sum}"
      c['Status'] = 'inválido'
      if sum != 1 and line >= 9
        puts "Erro checando Status soma status #{sum} line #{line}"
      else
        c['Status'] = "Ativo" if (c['Status Ativo']).to_i == 1
        c['Status'] = "Inativo" if (c['Status Inativo']).to_i == 1
        c['Status'] = "Parcial" if (c['Status Parcial']).to_i == 1
        c['Status'] = "Sem informação" if (c['Status Sem Informação']).to_i == 1
      end
      c.delete('Status Ativo')
      c.delete('Status Inativo')
      c.delete('Status Parcial')
      c.delete('Status Sem Informação')
      new_status_csv << c
      # guest['Total $ spent'] = guest['Total $ spent'].to_f #
      # new_guests_csv << guest # Add the new row into new_guests_csv
      line+=1
    end
    # ap new_status_csv

    CSV.open(@transformed, 'w') do |csv| # Create a new file updated_guests.csv
      new_status_csv.each do |row|
        csv.puts row
      end
    end

  end

  def self.schema_create

  end

end
h ={"is_template"=>"true",
"name"=>"pid",
"custom_values"=>
 {
  "UF"=>{"value"=>"PB", "public"=>"0"},
  "Tipo Telecentro"=>{"value"=>"Comunitário", "public"=>"0"},
  "Instituição Beneficiada"=>{"value"=>"Minha mãe 2", "public"=>"0"},
  "Instituição Parceira"=>{"value"=>"", "public"=>"0"},
  "Data da Adesão"=>{"value"=>"", "public"=>"0"},
  "Status"=>{"value"=>"Parcial", "public"=>"true"},
  "ID Telecentro"=>{"value"=>"", "public"=>"0"},
  "Município"=>{"value"=>"", "public"=>"0"},
  "Nome do responsável na instituição parceira  (Nome completo)"=>{"value"=>"", "public"=>"true"},
  "Telefone do responsável na instituição parceira"=>{"value"=>"", "public"=>"true"},
  "E-mail do responsável na instituição parceira"=>{"value"=>"", "public"=>"true"},
  "Nome do Responsável no Telecentro"=>{"value"=>"", "public"=>"true"},
  "CPF do Responsável no Telecentro"=>{"value"=>"", "public"=>"0"},
  "Telefone do Responsável no Telecentro"=>{"value"=>"", "public"=>"0"},
  "E-mail do Responsável no Telecentro"=>{"value"=>"", "public"=>"0"},
  "Localizado em Área Rural?"=>{"value"=>"Não", "public"=>"0"},
  "PCs Recebidos"=>{"value"=>"0", "public"=>"0"},
  "PCs Solicitados"=>{"value"=>"0", "public"=>"0"},
  "PCs doados"=>{"value"=>"0", "public"=>"0"},
  "PCs solicitados para serem doados"=>{"value"=>"0", "public"=>"0"},
  "Hora inalguração"=>{"value"=>"", "public"=>"0"},
  "Nome do Responsável no Telecentro (2)"=>{"value"=>"", "public"=>"0"}
},
"allow_members_to_invite"=>"1",
"invite_friends_only"=>"0",
"closed"=>"false",
"moderated_articles"=>"true",
"image_builder"=>{"label"=>""},
"secret"=>"0",
"public_profile"=>"true",
"redirect_l10n"=>"0",
"email_suggestions"=>"0",
"category_ids"=>[""]}



# class RedeBrasilPlugin::Pid < Community
#
#   def self.type_name
#     _('Pid')
#   end
#
#   # @e1 = Environment.default
#   #
#   # @community = create(Community, :environment => @e1, :name => 'pid test')
#   #
#   # @community_custom_field = CustomField.create(:name => "community_field", :format=>"myFormat", :default_value => "value for community", :customized_type=>"Community", :active => true, :environment => @e1)
#   # # @person_custom_field = CustomField.create(:name => "person_field", :format=>"myFormat", :default_value => "value for person", :customized_type=>"Person", :active => true, :environment => @e1)
#   # # @profile_custom_field = CustomField.create(:name => "profile_field", :format=>"myFormat", :default_value => "value for any profile", :customized_type=>"Profile", :active => true, :environment => @e1)
#
#
#
# end
