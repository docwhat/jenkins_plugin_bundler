# frozen_string_literal: true
require 'jenkins_plugin_bundler/plugin'

RSpec.describe Plugin do
  context 'with timestamper' do
    subject { described_class.new json_fixture('timestamper') }

    describe '#name' do
      subject { super().name }
      it { is_expected.to eq('timestamper') }
    end

    describe '#version' do
      subject { super().version }
      it { is_expected.to be_a Gem::Version }
    end
  end

  context 'with workflow-api' do
    subject { described_class.new json_fixture('workflow-api') }

    describe '#dependencies' do
      subject { super().dependencies }

      it 'should contain 1 requirement' do
        expect(subject.length).to eq(1)
      end

      it 'should not be optional' do
        expect(subject.first).to_not be_optional
      end

      it 'should be a Dependency' do
        expect(subject.first).to be_a Dependency
      end
    end
  end

  context 'with view-jobs-filter' do
    subject { described_class.new json_fixture('view-job-filters') }

    describe '#dependecies' do
      subject { super().dependencies }

      it 'should have optional dependencies' do
        expect(subject.find(&:optional?)).to be_truthy
      end
    end
  end
end
