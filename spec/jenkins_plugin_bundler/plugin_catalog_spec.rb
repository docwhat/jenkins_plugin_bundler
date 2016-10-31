# frozen_string_literal: true
require 'jenkins_plugin_bundler/plugin_catalog'

RSpec.describe PluginCatalog do
  subject(:catalog) { described_class.new fixture_path('update-center.json') }

  it 'contains plugins' do
    expect(subject.values.sample).to be_a Plugin
  end

  context 'with a dependency list' do
    subject { super().resolve deps }
    let(:deps) do
      [
        Dependency.new('timestamper', []),
        Dependency.new('github-organization-folder', '>= 1'),
        Dependency.new('workflow-api', '~> 2.0')
      ].shuffle
    end

    it { is_expected.to respond_to :count }
    it { is_expected.to include catalog['github-organization-folder'] }
    it { is_expected.to include catalog['workflow-api'] }
    it { is_expected.to include catalog['durable-task'] }
    it { is_expected.to include catalog['workflow-step-api'] }

    it 'has no duplicates' do
      is_expected.to match_array subject.uniq
    end

    it 'is sorted' do
      is_expected.to match_array subject.sort
    end
  end

  context 'with an unresolvable dependency list' do
    subject { -> { catalog.resolve deps } }
    let(:deps) do
      [
        Dependency.new('workflow-api', '~> 2.0'),
        Dependency.new('workflow-step-api', '~> 1.0')
      ]
    end

    it do
      is_expected.to raise_error(
        described_class::BadDependencyError,
        /required plugin.*workflow-step-api/
      )
    end
  end

  context 'with non-existant plugins' do
    subject { -> { catalog.resolve deps } }
    let(:deps) do
      [
        Dependency.new('not-a-real-plugin', '~> 2.0')
      ]
    end

    it do
      is_expected.to raise_error(described_class::NoSuchPluginError)
    end
  end

  context 'with optional non-existant plugins' do
    subject { -> { catalog.resolve deps } }
    let(:deps) do
      [
        Dependency.new('view-job-filters', [])
      ]
    end

    it do
      # m2-extra-steps isn't available, and shouldn't cause a problem.
      is_expected.not_to raise_error
    end
  end
end
