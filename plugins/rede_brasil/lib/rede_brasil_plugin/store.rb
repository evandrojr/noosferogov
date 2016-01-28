class RedeBrasilPlugin::Store
  @data = {}

  class << self
    attr_accessor :data
  end
end
