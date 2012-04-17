require 'mustache'
require 'procure/procfile'

module Procure
  class Builder
    attr_accessor :procfile, :name

    def initialize
      @procfile = Procure::Procfile.new 'Procfile'
      @name = File.basename Dir.pwd
    end

    def entries
      procfile.entries
    end

    def service_definition
      render "ServiceDefinition.cscfg"
    end

    def service_configuration
      render "ServiceConfiguration.cscfg"
    end

    private

    def template_dir
      File.dirname(__FILE__) + "/../../templates/"
    end

    def render(name)
      # Test Hack: IO.read is not supported by FakeFS
      Mustache.render IO.read(template_dir + name), self
    end
  end
end