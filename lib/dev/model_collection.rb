require 'forwardable'

module Dev
  class ModelCollection
    extend Forwardable
    include Enumerable

    AlreadyAddedError = Class.new(Dev::Error)
    RecordNotFound = Class.new(Dev::Error)

    def_delegators :records, :empty?

    attr_reader :records, :record_class

    def initialize(records: [], record_class:)
      @records = Array(records)
      @record_class = record_class
      validate_all!
    end

    def validate_all!
      records.each(&:validate!)
    end

    def each(*args, &block)
      records.each(*args, &block)
    end

    def add(record)
      record.validate!
      already_added! if records.include?(record)
      records << record
    end

    def remove(record)
      records.delete(record) || not_found!(record)
    end

    def remove_by(attributes)
      record = find_by(attributes)
      records.delete(record) if record
    end

    def remove_by!(attributes)
      records.delete find_by!(attributes)
    end

    def find_by(attributes)
      records.detect { |r| match?(r, attributes) }
    end

    def find_by!(*args)
      find_by(*args) || not_found!
    end

    def find_all_by(attributes)
      records.select { |r| match?(r, attributes) }
    end

    def find_all_by!(attributes)
      expected = attributes.delete(:expect) { raise 'provide :expect when calling find_all_by!' }
      records = find_all_by(attributes)
      not_found! if records.length != expected
      records
    end

    private

    def match?(record, attributes)
      attributes.all? { |k,v| v === record.public_send(k) }
    end

    def already_added!(record = nil)
      message =
        if record
          "#{record} has already been added"
        else
          "#{record_class.name} has already been added"
        end

      raise AlreadyAddedError, message
    end

    def not_found!(record = nil)
      message =
        if record
          "#{record} could not be found"
        else
          "no matching #{record_class.name} could be found"
        end

      raise RecordNotFound, message
    end
  end
end
