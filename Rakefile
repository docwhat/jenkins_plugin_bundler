# frozen_string_literal: true
require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

RSpec::Core::RakeTask.new(:spec)

task default: [:spec, :rubocop]

RuboCop::RakeTask.new(:rubocop) do |t|
  t.options = %w(
    --display-style-guide
    --display-cop-names
    --format clang
  )
end
