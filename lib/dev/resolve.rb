
module Dev
  module Resolve
    module_function

    def project_for_name(name)
      Repository.projects.find_by(name: String(name))
    end

    def group_for_name(name)
      Repository.groups.find_by(name: String(name))
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

    # private

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

      projects_for_names(group.project_names) if group
    end
  end
end
