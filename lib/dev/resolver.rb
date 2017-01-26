
module Dev
  class Resolver
    def initialize(*collections)
      @collections = Array(collections)
    end

    def project_for_name(name)
      find_by_name(project_collections, name)
    end

    def group_for_name(name)
      find_by_name(group_collections, name)
    end

    def project_or_group_for_name(name)
      project_for_name(name) || group_for_name(name)
    end

    def projects_for_names(names)
      names = Array(names)

      result = { matches: Set.new, missing: Set.new }

      names.each do |name|
        resolved = _resolve_project_name(name)

        result[:matches].merge(resolved[:matches])
        result[:missing].merge(resolved[:missing])
      end

      result
    end

    private

    attr_reader :collections

    def project_collections
      @project_collections ||= collections.select { |collection| collection.record_class == Project }
    end

    def group_collections
      @group_collections ||= collections.select { |collection| collection.record_class == Group }
    end

    def find_by_name(collections, name)
      name = String(name)
      collections.find do |collection|
        found = collection.find_by(name: name)
        break(found) unless found.nil?
      end
    end

    def _resolve_project_name(name)
      _resolve_project_for_project_name(name) ||
        _resolve_projects_for_group_name(name) ||
        { matches: [], missing: [name] }
    end

    def _resolve_project_for_project_name(name)
      project = project_for_name(name)

      { matches: [project], missing: [] } if project
    end

    def _resolve_projects_for_group_name(name)
      group = group_for_name(name)

      projects_for_names(group.entry_names) if group
    end
  end
end
