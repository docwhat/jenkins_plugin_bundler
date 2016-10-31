# frozen_string_literal: true
require 'dependency'

## Used for loading Pluginfiles
#
# The style is cribbed from Bundler's dsl.rb
class Dsl
  def self.evaluate(pluginfile)
    builder = new
    builder.send(:eval_pluginfile, pluginfile.to_s)
    builder.dependencies
  end

  attr_reader :dependencies

  def initialize
    @dependencies = []
  end

  def plugin(name, version = nil)
    version = ['>= 0'] if version.nil?
    dep = Dependency.new(name, version, false)

    @dependencies << dep
  end

  private

  def eval_pluginfile(pluginfile)
    contents = File.read(pluginfile.to_s)
    instance_eval(contents, pluginfile.to_s, 1)
  rescue StandardError => e
    message = 'There was an error parsing' \
      "`#{File.basename pluginfile.to_s}`: #{e.message}"

    raise DslError.new(message, pluginfile, e.backtrace, contents)
  end

  # Custom error
  class DslError < StandardError
  end
end
