class RedeBrasilPlugin < Noosfero::Plugin

  require_relative './rede_brasil_plugin/custom_fields_filler'
  require_relative './rede_brasil_plugin/pids_loader'
  require_relative './rede_brasil_plugin/transform'

  def self.plugin_name
    # FIXME
    "RedeBrasilPlugin"
  end

  def self.plugin_description
    # FIXME
    _("Plugin for the Rede Brasil Digital portal.")
  end

  def self.fill_custom_fiels
    RedeBrasilPlugin::CustomFieldsFiller.fill_data
  end

  def self.transform
    RedeBrasilPlugin::Transform.status
  end

  def self.load_pids
    RedeBrasilPlugin::PidsLoader.load
  end

  def self.load_all_from_scratch
    transform
    fill_custom_fiels
    load_pids
  end

end
