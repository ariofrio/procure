require 'mustache'
require 'procure/procfile'

module Procure
  class Builder
    attr_accessor :procfile, :name

    def initialize
      @procfile = Procure::Procfile.new 'Procfile'
      @name = File.basename Dir.pwd
    end

    def build
      build_app
      build_roles
    end

    def build_app
      FileUtils.mkdir_p 'azure'
      Dir.chdir 'azure' do
        File.open("ServiceConfiguration.cscfg", 'w') {|f| f.write service_configuration }
        File.open("ServiceDefinition.cscfg", 'w') {|f| f.write service_definition }
      end
    end

    def build_roles
      FileUtils.mkdir_p 'azure'
      Dir.chdir 'azure' do
        procfile.entries.each {|entry| build_role(entry) }
      end
    end

    def build_role(entry)
      dir = 'WorkerRole' + entry.name.capitalize
      Dir.mkdir dir
      Dir.chdir dir { language.create_role }
    end

    def service_definition
      render "ServiceDefinition.cscfg"
    end
    def service_configuration
      render "ServiceConfiguration.cscfg"
    end

    def self.template_dir
      File.dirname(__FILE__) + "/../../templates/"
    end

    private

    def render(name)
      FakeFS.without do
        Mustache.render File.read(self.class.template_dir + name), self
      end
    end
  end
end