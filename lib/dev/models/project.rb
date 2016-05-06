
module Dev
  class Project < Model
    define_singleton_method(:name) { 'Project' }

    attr_reader :name, :path

    def initialize(name:, path:)
      @name = name
      @path = Pathname(path)
    end

    def ==(other)
      path.realpath == other.realpath && name.casecmp(other.name).zero?
    end

    def validate
      catch(:invalid) do
        is_a_file? &&
        is_readable? &&
        is_named_docker_compose?
        false
      end
    end

    def directory
      path.dirname
    end

    def to_s
      name
    end

    private

    # this defines the serialized value of this object
    def marshal_dump
      {
        name: name,
        path: path.realpath
      }
    end

    def marshal_load(hash)
      @name = hash[:name]
      @path = Pathname(hash[:path])
    end

    def invalid(reason)
      throw :invalid, reason
    end

    def is_a_file?
      path.file? || invalid('not a valid file, is this a directory?')
    end

    def is_readable?
      path.readable? || invalid('the given file is not readable.')
    end

    def is_named_docker_compose?
      path.basename.to_s == 'docker-compose.yml' || invalid('must be named docker-compose.yml')
    end
  end
end
