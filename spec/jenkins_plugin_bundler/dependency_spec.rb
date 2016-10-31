# frozen_string_literal: true
require 'jenkins_plugin_bundler/dependency'

RSpec.describe JenkinsPluginBundler::Dependency do
  subject { described_class.new name, version }
  let(:name) { %w(joe nancy roger).sample }
  let(:version) { ['~> 1.0', '!= 1.0.2'] }

  # Create a fake Plugin instance
  def plugin(name, version = nil)
    version = "#{rand 99}.#{rand 99}.#{rand 99}" if version.nil?
    OpenStruct.new name: name, version: Gem::Version.new(version)
  end

  context 'with a random dependency' do
    describe '#name' do
      subject { super().name }
      it { is_expected.to eq(name) }
    end

    describe '#version' do
      subject { super().version }
      it { is_expected.to be_a Gem::Requirement }
    end

    describe '#to_s' do
      subject { super().to_s }
      it { is_expected.to include(version.first) }
      it { is_expected.to include(version.last) }
    end

    describe '#eql?' do
      let(:one) { described_class.new name, version }
      let(:two) { described_class.new name, version }
      it 'should return true for identical dependencies' do
        expect(one).to eql(two)
      end
    end

    describe '#satisfied_by?' do
      context 'an acceptable plugin' do
        subject { super().satisfied_by? plugin(name, "1.#{rand 99}") }
        it { is_expected.to be_truthy }
      end

      context 'wrong plugin' do
        subject { super().satisfied_by? plugin('wrong') }
        it { is_expected.to be_falsy }
      end

      context 'plugin v1.0.2' do
        subject { super().satisfied_by? plugin(name, '1.0.2') }
        it { is_expected.to be_falsy }
      end
    end
  end

  context 'with no version' do
    let(:version) { nil }

    describe '#to_s' do
      subject { super().to_s }
      it { is_expected.to eq("#{name}:latest") }
    end

    describe '#satisfied_by?' do
      context 'an acceptable plugin' do
        subject { super().satisfied_by? plugin(name) }
        it { is_expected.to be_truthy }
      end

      context 'wrong plugin' do
        subject { super().satisfied_by? plugin('wrong') }
        it { is_expected.to be_falsy }
      end
    end
  end
end
