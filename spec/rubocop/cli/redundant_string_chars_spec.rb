# frozen_string_literal: true

RSpec.describe 'RuboCop::CLI string chars safety', :isolated_environment do # rubocop:disable RSpec/DescribeClass
  subject(:cli) { RuboCop::CLI.new }

  include_context 'mock console output'

  around do |example|
    previous_config = RuboCop::ConfigLoader.default_configuration
    RuboCop::ConfigLoader.default_configuration = nil
    RuboCop::ConfigLoader.default_configuration.for_all_cops['SuggestExtensions'] = false
    RuboCop::ConfigLoader.default_configuration.for_all_cops['NewCops'] = 'disable'
    example.run
  ensure
    RuboCop::ConfigLoader.default_configuration = previous_config
  end

  before do
    File.write('.rubocop.yml', <<~YAML)
      plugins:
        - rubocop-performance
      AllCops:
        DisabledByDefault: true
      Performance/RedundantStringChars:
        Enabled: true
    YAML
    File.write('example.rb', 'string.chars[0]')
  end

  it 'omits suggestions in safe mode' do
    expect(cli.run(['--safe', 'example.rb'])).to eq(0), $stderr.string
  end

  it 'does not change a possible String subclass during safe autocorrection' do
    expect(cli.run(['--autocorrect', 'example.rb'])).to eq(1), $stderr.string
    expect(File.read('example.rb')).to eq('string.chars[0]')
  end

  it 'keeps corrections available when unsafe autocorrection is requested' do
    expect(cli.run(['--autocorrect-all', 'example.rb'])).to eq(0), $stderr.string
    expect(File.read('example.rb')).to eq('string[0]')
  end
end
