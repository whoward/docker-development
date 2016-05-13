
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

    def down(project)
      staged_project = projects.find_by!(name: project.name)

      DockerCompose.new(staged_project).stop
    end

    def sync(project)
      yaml = DockerCompose.new(project).configuration

      yaml = Task::RepairGeneratedDockerCompose.new(yaml).call

      dir = directory.join(project.name)

      dir.mkpath unless dir.exist?

      dir.join('docker-compose.yml').write(yaml)
    end

    def remove(project)
      directory.join(project.name).rmtree
    end

    # private

    def invalidate!
      @projects = nil
    end

    def find_projects
      ensure_directory!
      directory.children.map { |c| Task::BuildProjectFromStageDirectory.new(c).project }
    end
  end
end
