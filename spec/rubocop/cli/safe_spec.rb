# frozen_string_literal: true

RSpec.describe 'RuboCop::CLI --safe', :isolated_environment do # rubocop:disable RSpec/DescribeClass
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
      Performance/ChainArrayAllocation:
        Enabled: true
    YAML
    File.write('example.rb', 'items.uniq.map { |item| item.to_s }')
  end

  it 'omits array mutation suggestions in safe mode' do
    expect(cli.run(['--safe', '--format', 'json', 'example.rb'])).to eq(0), $stderr.string
    expect(JSON.parse($stdout.string).dig('summary', 'offense_count')).to eq(0)
  end

  it 'keeps array mutation suggestions available outside safe mode' do
    expect(cli.run(['--format', 'json', 'example.rb'])).to eq(1), $stderr.string
    offenses = JSON.parse($stdout.string).fetch('files').flat_map { |file| file.fetch('offenses') }
    expect(offenses.map { |offense| offense.fetch('cop_name') }).to eq(['Performance/ChainArrayAllocation'])
  end
end
