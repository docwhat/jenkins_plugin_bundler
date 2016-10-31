# frozen_string_literal: true
require 'jenkins_plugin_bundler'

RSpec.describe JenkinsPluginBundler do
  it 'has a version number' do
    expect(JenkinsPluginBundler::VERSION).not_to be nil
  end
end
