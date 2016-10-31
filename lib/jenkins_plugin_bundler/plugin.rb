# frozen_string_literal: true
require 'jenkins_plugin_bundler/dependency'
require 'digest'

module JenkinsPluginBundler
  # Class to hold a plugin
  class Plugin
    include Comparable

    def initialize(plugin_hash)
      @hash = plugin_hash
    end

    %w(name url wiki title excerpt sha1).each do |n|
      define_method(n) { @hash.fetch(n) }
    end

    def version
      Gem::Version.new @hash['version']
    end

    def <=>(other)
      to_s <=> other.to_s
    end

    def dependencies
      @hash['dependencies']
        .map do |x|
          Dependency.new(x['name'], ">= #{x['version']}", x['optional'])
        end
    end

    def inspect
      "<Plugin name:#{name.inspect} version:#{version.inspect}>"
    end

    def filename
      "#{name}.jpi"
    end

    def verify(filename)
      sha1 == Digest::SHA1.file(filename).base64digest
    end

    def to_s
      "#{name}:#{version}"
    end
  end
end
