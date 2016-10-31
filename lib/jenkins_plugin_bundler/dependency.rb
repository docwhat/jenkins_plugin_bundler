# frozen_string_literal: true
require 'forwardable'

## A Jenkins plugin dependency
class Dependency
  attr_reader :name, :version, :optional
  extend Forwardable

  def initialize(name, version, optional = false)
    @name = name.freeze
    @version = Gem::Requirement.new(version).freeze
    @optional = optional
  end

  def_delegators :@version, :none?, :specific?, :exact?

  def optional?
    optional
  end

  def required?
    !optional?
  end

  def hash
    to_s.hash
  end

  def eql?(other)
    name == other.name && version == other.version
  end

  def satisfied_by?(plugin)
    name == plugin.name && version.satisfied_by?(plugin.version)
  end

  def to_s
    "#{name}:#{none? ? 'latest' : version}"
  end
end
