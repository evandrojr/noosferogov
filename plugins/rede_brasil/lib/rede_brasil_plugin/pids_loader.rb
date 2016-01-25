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

    @h ={
    "custom_values"=>{
      "Micros para Doação Solicitado"=>{"value"=>696969, "public"=>"0"},
      "Data"=>{"value"=>"2016-12-30", "public"=>"0"}
      }
    }


    def self.load
      Community.destroy_all
      line = 0
      CSV.foreach(@transformed, headers: true) do |r| # Iterate over each row of our CSV file
        line += 1
        # if line==1
        #   r.headers.each do |h|
        #     attr_accessible(h.to_sym)
        #   end
        # end
        next if line < 8
        r.delete('name')
        ap r
        c = Community.new
        c.name = r['Nome']
        c.save!
        ap r.to_hash

        c.update!(@h, without_protection: true)
        return
      end

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
  "ID Telecentro"=>{"value"=>"ewew", "public"=>"0"},
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
