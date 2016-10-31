# frozen_string_literal: true
require 'jenkins_plugin_bundler/plugin'

module JenkinsPluginBundler
  # Class to hold all plugins
  class PluginCatalog < Hash
    def initialize(json_file)
      super
      catalog = JSON.parse File.read(json_file)
      catalog['plugins'].each_pair { |k, v| self[k] = Plugin.new v }
      self.default_proc = lambda do |_x, p|
        raise NoSuchPluginError, "No such plugin: #{p}"
      end
    end

    def resolve(dependencies)
      resolve_with_plugins(dependencies, [], []).sort
    end

    private

    def resolve_with_plugins(dependencies, resolved_dependencies, plugins)
      return plugins if dependencies.empty?

      all_plugins = resolve_and_check(dependencies, plugins)
      new_dependencies = all_plugins.map(&:dependencies).flatten.uniq -
                         dependencies - resolved_dependencies
      old_dependencies = dependencies + resolved_dependencies
      (
        all_plugins +
        resolve_with_plugins(new_dependencies, old_dependencies, all_plugins)
      ).uniq
    end

    def resolve_and_check(dependencies, plugins)
      (
        [] +
        plugins +
        dependencies.select(&:required?).map { |d| resolve_dependency d }
      )
        .compact
        .uniq
        .tap { |new_plugins| check_dependencies(dependencies, new_plugins) }
    end

    def resolve_dependency(dependency)
      return self[dependency.name] if dependency.required?
      fetch(dependency.name, nil)
    end

    def check_dependencies(dependencies, plugins)
      dependencies.each do |dep|
        next if dep.optional?
        next if plugins.find { |p| dep.satisfied_by? p }
        if dep.required?
          raise BadDependencyError, "Unable to find required plugin #{dep}"
        end
      end
    end

    class BadDependencyError < StandardError; end
    class NoSuchPluginError < StandardError; end
  end
end
