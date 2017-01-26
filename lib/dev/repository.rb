require 'pstore'

module Dev
  module Repository
    module_function

    def storage_filename
      Pathname(Dir.home).join('.dev-store')
    end

    def store
      @store ||= PStore.new(storage_filename)
    end

    def load!
      @store = nil # force refresh

      store.transaction(true) do
        @config = store[:config]
        @projects = load_projects!
        @groups = load_groups!
      end

      self
    end

    def save!
      store.transaction do
        store[:projects] = projects.records
        store[:groups] = groups.records
        store[:config] = config
      end
      self
    end

    def transaction(context = nil, &block)
      instance_exec(context, &block)
      save!
    end

    def config
      @config ||= {}
    end

    def projects
      @projects ||= ModelCollection.new(record_class: Project)
    end

    def groups
      @groups ||= ModelCollection.new(record_class: Group)
    end

    # private

    def load_projects!
      ModelCollection.new(records: store[:projects], record_class: Project)
    end

    def load_groups!
      ModelCollection.new(records: store[:groups], record_class: Group)
    end
  end
end
