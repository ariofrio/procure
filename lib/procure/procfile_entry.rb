module Procure
  class ProcfileEntry
    attr_reader :name
    attr_reader :command
    attr_accessor :color

    def initialize(name, command)
      @name = name
      @command = command
    end

    def concurrency
      1
    end

    def web?
      name == 'web'
    end

  end
end