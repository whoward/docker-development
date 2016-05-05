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
        @projects = store[:projects]
      end
    end

    def save!
      store.transaction do
        store[:projects] = projects
      end
    end

    def transaction(&block)
      instance_exec(&block)
      save!
    end

    def projects
      @projects ||= []
    end

    def add_project(project)
      project.validate!
      project_already_added! if projects.include?(project)
      projects << project
    end

    def remove_project(project)
      projects.delete(project) || project_not_found!
    end

    def project_already_added!
      raise AlreadyAddedError, 'project has already been added'
    end

    def project_not_found!
      raise RecordNotFound, 'no matching project could be found'
    end
  end
end
