Dir[File.dirname(__FILE__) + 'languages/*.rb'].each {|file| require file }

module Procure
  module Languages
    class << self
      include Enumerable

      def each(&block)
        to_a.each &block
      end

      # Return a list of supported languages, in order of preference
      def to_a
        [:Java].map {|lang| Procure::Languages.const_get lang}
      end

      def recognize(entry)
        detect { |x| x.recognize }
      end
    end
  end
end