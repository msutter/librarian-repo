require 'librarian/repo/util'

module Librarian
  module Repo
    module Iterator

      # evaluate a module and add it our @repos instance variable
      def repo(name, options = {})
        @repos ||= {}
        full_name   = name
        module_name = name.split('/', 2).last

        case
        when options[:git]
          @repos[:git] ||= {}
          @repos[:git][module_name] = options.merge(:name => module_name, :full_name => full_name)
        when options[:tarball]
          @repos[:tarball] ||= {}
          @repos[:tarball][module_name] = options.merge(:name => module_name, :full_name => full_name)
        else
          @repos[:forge] ||= {}
          @repos[:forge][module_name] = options.merge(:name => module_name, :full_name => full_name)
          #abort('only the :git and :tarball providers are currently supported')
        end
      end

      def repos
        @repos
      end

      def clear_repos
        @repos = nil
      end

      # iterate through all repos
      def each_module(&block)
        (@repos || {}).each do |type, repos|
          (repos || {}).values.each do |repo|
            yield repo
          end
        end
      end

      # loop over each module of a certain type
      def each_module_of_type(type, &block)
        abort("undefined type #{type}") unless [:git, :tarball].include?(type)
        ((@repos || {})[type] || {}).values.each do |repo|
          yield repo
        end
      end

    end
  end
end
