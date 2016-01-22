class RedeBrasilPlugin::PidsLoader

  @UFs=["AC",	"AL",	"AP",	"AM",	"BA",	"CE",	"DF",	"ES",	"GO",	"MA",	"MT",	"MS",	"MG",	"PR",	"PB",	"PA",	"PE",	"PI",	"RJ",	"RN",	"RS",	"RO",	"RR",	"SC",	"SE",	"SP",	"TO"]
  @pids_type =["Comunitário", "Escola Aberta", "Espaço Cidadão", "Ponto Cultural"]

  def self.load
    c = Community.new
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
