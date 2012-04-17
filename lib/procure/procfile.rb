require "procure/procfile_entry"

module Procure
  class Procfile
    attr_reader :entries

    def initialize(filename)
      @entries = parse_procfile(filename)
    end

    def [](name)
      entries.detect { |entry| entry.name == name }
    end

    def process_names
      entries.map(&:name)
    end

  private

    def parse_procfile(filename)
      File.read(filename).split("\n").map do |line|
        if line =~ /^([A-Za-z0-9_]+):\s*(.+)$/
          Procure::ProcfileEntry.new($1, $2)
        end
      end.compact
    end

  end
end