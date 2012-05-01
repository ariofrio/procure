require 'open-uri'
require 'net/http'

module Procure
  module Languages
    module Java
      class << self
        def jdk
          "http://edelivery.oracle.com/otn-pub/java/jdk/6u31-b05/jdk-6u31-windows-x64.exe"
        end
        def maven
          "http://mirrors.ibiblio.org/apache/maven/binaries/apache-maven-3.0.4-bin.zip"
        end

        def recognize
          File.file? 'package.xml'
        end

        def download(uri, filename)
          File.open filename, 'w' do |file|
            Net::HTTP.get_response(URI(uri)) do |response|
             response.read_body do |segment|
               file.write segment
             end
            end
          end
        end

        def file(filename)
          File.read(Procure::Builder.template_dir + filename)
        end

        def create_role
          download jdk, 'jdk.exe'
          # open jdk, 'Cookie' => 'oraclelicensejdk-6u31-oth-JPR=accept-securebackup-cookie;s_cc=true' do |src|
          #   IO.copy_stream src, 'jdk.exe'
          # end
          download maven, 'maven.zip'

          File.open('utils.ps1', 'w') {|f| f.write file('utils.ps1') }
          File.open('setup.ps1', 'w') {|f| f.write file('setup-java.ps1') }
        end
      end
    end
  end
end
