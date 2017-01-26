require 'set'

module Dev
  class Group < Model
    attr_reader :name, :entry_names

    def initialize(name:, entry_names: [])
      @name = String(name)
      @entry_names = Set.new(entry_names)
    end

    def ==(other)
      entry_names == other.entry_names && name.casecmp(other.name).zero?
    end

    def validate!
      true
    end

    def to_s
      name
    end
  end
end
