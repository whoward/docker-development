
module Dev
  module Stage
    module_function

    def directory
      System.staging_directory
    end

    def ensure_directory!
      directory.mkpath unless directory.exist?
    end

    # returns a collection of projects on the actual filesystem
    def projects
      @projects ||= ModelCollection.new(
        records: find_projects,
        record_class: Project
      )
    end

    def up(project)
      staged_project = projects.find_by!(name: project.name)

      DockerCompose.new(staged_project).up
    end

    def sync(project)
      dir = directory.join(project.name)

      dir.mkpath unless dir.exist?

      dir.join('docker-compose.yml')
         .write DockerCompose.new(project).configuration
    end

    # private

    def invalidate!
      @projects = nil
    end

    def find_projects
      ensure_directory!
      directory.children.map { |c| build_project_from_stage_directory(c) }
    end

    def build_project_from_stage_directory(path)
      Project.new(
        name: path.basename,
        path: path.join('docker-compose.yml')
      ).tap(&:validate!)
    rescue Dev::InvalidError => e
      invalid_staged_project!(path, e)
    end

    def invalid_staged_project!(path, ex)
      raise Dev::InvalidError, "the staged project at #{path} is invalid because #{ex.message.inspect}"
    end
  end
end
