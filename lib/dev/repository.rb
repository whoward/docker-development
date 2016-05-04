require 'yaml/store'

module Dev
  module Repository
    AlreadyAddedError = Class.new(Dev::Error)
    RecordNotFound = Class.new(Dev::Error)

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
        @apps = store[:apps]
      end
    end

    def save!
      store.transaction do
        store[:apps] = apps
      end
    end

    def transaction(&block)
      instance_exec(&block)
      save!
    end

    def apps
      @apps ||= []
    end

    def add_app(app)
      app.validate!
      app_already_added! if apps.include?(app)
      apps << app
    end

    def remove_app(app)
      apps.delete(app) || app_not_found!
    end

    def app_already_added!
      raise AlreadyAddedError, 'app has already been added'
    end

    def app_not_found!
      raise RecordNotFound, 'no matching app could be found'
    end
  end
end
