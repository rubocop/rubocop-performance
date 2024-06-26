# frozen_string_literal: true

require 'fileutils'

RSpec.describe 'RuboCop::CLI --autocorrect', :isolated_environment do # rubocop:disable RSpec/DescribeClass
  subject(:cli) { RuboCop::CLI.new }

  include_context 'mock console output'

  before do
    RuboCop::ConfigLoader.default_configuration = nil
    RuboCop::ConfigLoader.default_configuration.for_all_cops['SuggestExtensions'] = false
    RuboCop::ConfigLoader.default_configuration.for_all_cops['NewCops'] = 'disable'
  end

  it 'corrects `Performance/ConstantRegexp` with `Performance/RegexpMatch`' do
    create_file('.rubocop.yml', <<~YAML)
      Performance/ConstantRegexp:
        Enabled: true
      Performance/RegexpMatch:
        Enabled: true
    YAML
    source = <<~RUBY
      foo if bar =~ /\#{CONSTANT}/
    RUBY
    create_file('example.rb', source)
    expect(cli.run(['--autocorrect', '--only', 'Performance/ConstantRegexp,Performance/RegexpMatch'])).to eq(0)
    expect(File.read('example.rb')).to eq(<<~RUBY)
      foo if /\#{CONSTANT}/o.match?(bar)
    RUBY
  end

  it 'corrects `Performance/BlockGivenWithExplicitBlock` with `Lint/UnusedMethodArgument`' do
    source = <<~RUBY
      def foo(&block)
        block_given?
      end
    RUBY
    create_file('example.rb', source)
    expect(
      cli.run(['--autocorrect', '--only', 'Performance/BlockGivenWithExplicitBlock,Lint/UnusedMethodArgument'])
    ).to eq(0)
    expect(File.read('example.rb')).to eq(<<~RUBY)
      def foo()
        block_given?
      end
    RUBY
  end

  it 'corrects `Performance/BlockGivenWithExplicitBlock` with `Naming/BlockForwarding`' do
    source = <<~RUBY
      def foo(&block)
        block_given?
        bar(&block)
      end
    RUBY
    create_file('example.rb', source)
    expect(
      cli.run(['--autocorrect', '--only', 'Performance/BlockGivenWithExplicitBlock,Naming/BlockForwarding'])
    ).to eq(0)
    expect(File.read('example.rb')).to eq(<<~RUBY)
      def foo(&block)
        block
        bar(&block)
      end
    RUBY
  end

  private

  def create_file(file_path, content)
    file_path = File.expand_path(file_path)

    dir_path = File.dirname(file_path)
    FileUtils.mkdir_p(dir_path)

    File.write(file_path, content)

    file_path
  end
end
