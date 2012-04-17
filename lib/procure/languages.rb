require 'fakefs/safe'
FakeFS.without do
  Dir[File.dirname(__FILE__) + '/languages/*.rb'].each {|file| require file }
end

module Procure
  module Languages
    class << self
      include Enumerable

      def each(&block)
        to_a.each &block
      end

      # Return a list of supported languages, in order of preference
      def to_a
        [:Java, :None].map {|lang| Procure::Languages.const_get lang}
      end

      def recognize
        detect { |x| x.recognize }
      end
    end
  end
end