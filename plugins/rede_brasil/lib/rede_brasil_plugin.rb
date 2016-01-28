class RedeBrasilPlugin < Noosfero::Plugin

  require_relative './rede_brasil_plugin/custom_fields_filler'
  require_relative './rede_brasil_plugin/pids_loader'
  require_relative './rede_brasil_plugin/transform'
  require_relative './rede_brasil_plugin/better_csv_row'

  def self.plugin_name
    # FIXME
    "RedeBrasilPlugin"
  end

  def self.plugin_description
    # FIXME
    _("Plugin for the Rede Brasil Digital portal.")
  end

  def self.fill_custom_fields
    RedeBrasilPlugin::CustomFieldsFiller.fill_data
  end

  def self.destroy_custom_fields
    RedeBrasilPlugin::CustomFieldsFiller.destroy
  end

  def self.transform
    RedeBrasilPlugin::Transform.status
  end

  def self.load_pids
    RedeBrasilPlugin::PidsLoader.load
  end

  def self.load_all_from_scratch
    transform
    destroy_custom_fields
    fill_custom_fiels
    load_pids
  end

end
