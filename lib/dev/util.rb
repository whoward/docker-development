
module Dev
  module Util
    module_function

    def require_tree(directory)
      Pathname(directory).find
                         .select { |p| p.extname == '.rb' }
                         .each { |p| require p }
    end
  end
end
