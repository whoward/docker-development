
module Dev
  module Command
    class Base
      def self.inherited(klass)
        klass.define_singleton_method(:perform) do |*args, &block|
          new(*args, &block).perform
        end
      end

      attr_reader :options

      def initialize(options:)
        @options = options
      end

      protected

      def log
        Dev.logger
      end
    end
  end
end
