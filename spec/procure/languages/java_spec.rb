require 'spec_helper'
require 'procure/languages/java'

describe Procure::Languages::Java, :fakefs do
  subject { Procure::Languages::Java }

  xit "has download links that work" do
    def head(uri)
      uri = URI(uri)
      Net::HTTP.new(uri.host, uri.port).start do |http|
        http.request_head(uri.request_uri)
      end
    end

    WebMock.disable!
    head(subject.jdk).code.should == 200
    head(subject.maven).code.should == 200
    WebMock.enable!
  end

  context do
    before do
     stub_request(:any, subject.jdk)
     stub_request(:any, subject.maven)
    end

    it "creates a complete role" do
      subject.create_role

      File.exists? 'jdk.exe'
      File.exists? 'maven.zip'

      File.exists? 'setup.ps1'
      File.exists? 'utils.ps1'
    end
  end
end