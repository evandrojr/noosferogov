class RedeBrasilPlugin::Pid < ActiveRecord::Base

  belongs_to :owner, :polymorphic => true
  attr_accessible :owner, :name, :description, :level, :custom_fields, :title
  serialize :custom_fields

  @e1 = Environment.default
  @community = create(Community, :environment => @e1, :name => 'my new community')

  @community_custom_field = CustomField.create(:name => "community_field", :format=>"myFormat", :default_value => "value for community", :customized_type=>"Community", :active => true, :environment => @e1)
  @person_custom_field = CustomField.create(:name => "person_field", :format=>"myFormat", :default_value => "value for person", :customized_type=>"Person", :active => true, :environment => @e1)
  @profile_custom_field = CustomField.create(:name => "profile_field", :format=>"myFormat", :default_value => "value for any profile", :customized_type=>"Profile", :active => true, :environment => @e1)

  @e1.reload

end
