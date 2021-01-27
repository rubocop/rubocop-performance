# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Performance::UriDefaultParser, :config do
  let(:config) { RuboCop::Config.new }

  it 'registers an offense when using `URI::Parser.new`' do
    expect_offense(<<~RUBY)
      URI::Parser.new.make_regexp
      ^^^^^^^^^^^^^^^ Use `URI::DEFAULT_PARSER` instead of `URI::Parser.new`.
    RUBY
  end

  it 'registers an offense when using `::URI::Parser.new`' do
    expect_offense(<<~RUBY)
      ::URI::Parser.new.make_regexp
      ^^^^^^^^^^^^^^^^^ Use `::URI::DEFAULT_PARSER` instead of `::URI::Parser.new`.
    RUBY
  end

  it 'autocorrects `URI::DEFAULT_PARSER`' do
    new_source = autocorrect_source('URI::Parser.new.make_regexp')

    expect(new_source).to eq 'URI::DEFAULT_PARSER.make_regexp'
  end

  it 'autocorrects `::URI::DEFAULT_PARSER`' do
    new_source = autocorrect_source('::URI::Parser.new.make_regexp')

    expect(new_source).to eq '::URI::DEFAULT_PARSER.make_regexp'
  end
end
