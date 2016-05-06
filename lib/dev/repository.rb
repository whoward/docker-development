require 'yaml/store'

module Dev
  module Repository
    module_function

    def storage_filename
      Pathname(Dir.home).join('.dev-store')
    end

    def store
      @store ||= YAML::Store.new(storage_filename)
    end

    def load!
      @store = nil # force refresh

      store.transaction(true) do
        @config = store[:config]

        @projects = ModelCollection.new(
          records: store[:projects],
          record_class: Project
        )
      end

      self
    end

    def save!
      store.transaction do
        store[:projects] = projects.records
        store[:config] = config
      end
      self
    end

    def transaction(&block)
      instance_exec(&block)
      save!
    end

    def config
      @config ||= {}
    end

    def projects
      @projects ||= ModelCollection.new(record_class: Project)
    end
  end
end
