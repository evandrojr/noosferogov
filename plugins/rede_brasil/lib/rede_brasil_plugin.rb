class RedeBrasilPlugin < Noosfero::Plugin
  require_relative './rede_brasil_plugin/pids_loader'

  def self.plugin_name
    # FIXME
    "RedeBrasilPlugin"
  end

  def self.plugin_description
    # FIXME
    _("A plugin that does this and that.")
  end

  def self.load
    RedeBrasilPlugin::PidsLoader.load
  end

end
