require 'spec_helper'
require 'procure/builder'

describe Procure::Builder, :fakefs do
  describe "with a one-role app" do
    before(:each) do
      Dir.mkdir 'myapp'
      File.open 'myapp/Procfile', 'w' do |f|
        f << "web: mvn -Djetty.port=$PORT jetty:run"
      end
    end

    it "generates Azure service configuration" do
      Dir.chdir 'myapp' do
        subject.service_configuration.should be_equivalent_to <<-EOF
          <?xml version="1.0"?>
          <ServiceConfiguration xmlns="http://schemas.microsoft.com/ServiceHosting/2008/10/ServiceConfiguration" serviceName="myapp" osFamily="2" osVersion="*">
            <Role name="WorkerRoleWeb">
              <Instances count="1" />
            </Role>
          </ServiceConfiguration>
        EOF
      end
    end

    it "generates Azure service definition" do
      Dir.chdir 'myapp' do
        subject.service_definition.should be_equivalent_to <<-EOF
        <?xml version="1.0" encoding="utf-8"?>
        <ServiceDefinition xmlns="http://schemas.microsoft.com/ServiceHosting/2008/10/ServiceDefinition" name="myapp">
          <WorkerRole name="WorkerRoleWeb" vmsize="ExtraSmall">
            <Startup>
              <Task commandLine="powershell setup.ps1" executionContext="elevated" />
            </Startup>
            <Runtime>
              <Environment>
                <Variable name="ADDRESS">
                  <RoleInstanceValue xpath="/RoleEnvironment/CurrentInstance/Endpoints/Endpoint[@name='HttpIn']/@address" />
                </Variable>
                <Variable name="PORT">
                  <RoleInstanceValue xpath="/RoleEnvironment/CurrentInstance/Endpoints/Endpoint[@name='HttpIn']/@port" />
                </Variable>
                <Variable name="EMULATED">
                  <RoleInstanceValue xpath="/RoleEnvironment/Deployment/@emulated" />
                </Variable>
              </Environment>
              <EntryPoint>
                <ProgramEntryPoint commandLine="run.cmd" setReadyOnProcessStart="true" />
              </EntryPoint>
            </Runtime>
            <Endpoints>
              <InputEndpoint name="HttpIn" protocol="tcp" port="80" />
            </Endpoints>
          </WorkerRole>
        </ServiceDefinition>
        EOF
      end
    end

    it "builds the application (excluding roles)" do
      Dir.chdir "myapp" do
        subject.build_app
        Dir.chdir "azure" do
          File.exists? 'ServiceConfiguration.cscfg'
          File.exists? 'ServiceDefinition.cscfg'
        end
      end
    end
  end

  describe "with a three-role app" do
    before(:each) do
      Dir.mkdir 'myapp'
      File.open 'myapp/Procfile', 'w' do |f|
        f << <<-EOF.unindent
          web: mvn -Djetty.port=$PORT jetty:run
          worker: java -cp target/classes:target/dependency/* Worker
          mailer: java -cp target/classes:target/dependency/* Mailer
        EOF
      end
    end

    it "generates Azure service configuration" do
      Dir.chdir 'myapp' do
        subject.service_configuration.should be_equivalent_to <<-EOF
          <?xml version="1.0"?>
          <ServiceConfiguration xmlns="http://schemas.microsoft.com/ServiceHosting/2008/10/ServiceConfiguration" serviceName="myapp" osFamily="2" osVersion="*">
            <Role name="WorkerRoleWeb">
              <Instances count="1" />
            </Role>
            <Role name="WorkerRoleWorker">
              <Instances count="1" />
            </Role>
            <Role name="WorkerRoleMailer">
              <Instances count="1" />
            </Role>
          </ServiceConfiguration>
        EOF
      end
    end

    it "generates Azure service definition" do
      Dir.chdir 'myapp' do
        subject.service_definition.should be_equivalent_to <<-EOF
        <?xml version="1.0" encoding="utf-8"?>
        <ServiceDefinition xmlns="http://schemas.microsoft.com/ServiceHosting/2008/10/ServiceDefinition" name="myapp">
          <WorkerRole name="WorkerRoleWeb" vmsize="ExtraSmall">
            <Startup>
              <Task commandLine="powershell setup.ps1" executionContext="elevated" />
            </Startup>
            <Runtime>
              <Environment>
                <Variable name="ADDRESS">
                  <RoleInstanceValue xpath="/RoleEnvironment/CurrentInstance/Endpoints/Endpoint[@name='HttpIn']/@address" />
                </Variable>
                <Variable name="PORT">
                  <RoleInstanceValue xpath="/RoleEnvironment/CurrentInstance/Endpoints/Endpoint[@name='HttpIn']/@port" />
                </Variable>
                <Variable name="EMULATED">
                  <RoleInstanceValue xpath="/RoleEnvironment/Deployment/@emulated" />
                </Variable>
              </Environment>
              <EntryPoint>
                <ProgramEntryPoint commandLine="run.cmd" setReadyOnProcessStart="true" />
              </EntryPoint>
            </Runtime>
            <Endpoints>
              <InputEndpoint name="HttpIn" protocol="tcp" port="80" />
            </Endpoints>
          </WorkerRole>
          <WorkerRole name="WorkerRoleWorker" vmsize="ExtraSmall">
            <Startup>
              <Task commandLine="powershell setup.ps1" executionContext="elevated" />
            </Startup>
            <Runtime>
              <Environment>
                <Variable name="ADDRESS">
                  <RoleInstanceValue xpath="/RoleEnvironment/CurrentInstance/Endpoints/Endpoint[@name='HttpIn']/@address" />
                </Variable>
                <Variable name="PORT">
                  <RoleInstanceValue xpath="/RoleEnvironment/CurrentInstance/Endpoints/Endpoint[@name='HttpIn']/@port" />
                </Variable>
                <Variable name="EMULATED">
                  <RoleInstanceValue xpath="/RoleEnvironment/Deployment/@emulated" />
                </Variable>
              </Environment>
              <EntryPoint>
                <ProgramEntryPoint commandLine="run.cmd" setReadyOnProcessStart="true" />
              </EntryPoint>
            </Runtime>
          </WorkerRole>
          <WorkerRole name="WorkerRoleMailer" vmsize="ExtraSmall">
            <Startup>
              <Task commandLine="powershell setup.ps1" executionContext="elevated" />
            </Startup>
            <Runtime>
              <Environment>
                <Variable name="ADDRESS">
                  <RoleInstanceValue xpath="/RoleEnvironment/CurrentInstance/Endpoints/Endpoint[@name='HttpIn']/@address" />
                </Variable>
                <Variable name="PORT">
                  <RoleInstanceValue xpath="/RoleEnvironment/CurrentInstance/Endpoints/Endpoint[@name='HttpIn']/@port" />
                </Variable>
                <Variable name="EMULATED">
                  <RoleInstanceValue xpath="/RoleEnvironment/Deployment/@emulated" />
                </Variable>
              </Environment>
              <EntryPoint>
                <ProgramEntryPoint commandLine="run.cmd" setReadyOnProcessStart="true" />
              </EntryPoint>
            </Runtime>
          </WorkerRole>
        </ServiceDefinition>
        EOF
      end
    end
  end
end