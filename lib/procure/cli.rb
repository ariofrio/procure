require 'procure/builder'

module Procure
  module CLI
    def self.start
      builder = Procure::Builder.new
      builder.build
    end
  end
end
