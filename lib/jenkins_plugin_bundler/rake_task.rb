# frozen_string_literal: true
require 'rake/task'

# A class to download plugins
class PluginTask < Rake::Task
  attr_accessor :plugin

  class << self
    def define_task(plugin) # rubocop:disable MethodLength
      args = [{
        "container/plugins/#{plugin.name}.jpi" => %w(
          Pluginfile update-center.json container/plugins
        )
      }]

      block = proc do |t|
        Rake.sh(
          'curl',
          '--retry', '3',
          '--retry-delay', '5',
          '-sSLf',
          '-o', t.name,
          plugin.url
        )
      end

      super(*args, &block).tap { |t| t.plugin = plugin }
    end

    # Apply the scope to the task name according to the rules for this kind
    # of task.  File based tasks ignore the scope when creating the name.
    def scope_name(_scope, task_name)
      task_name
    end
  end

  def needed?
    !File.exist?(name) || !plugin.verify(name)
  end
end

def plugin_task(plugin)
  PluginTask.define_task(plugin)
end
