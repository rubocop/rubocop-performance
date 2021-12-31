# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Performance::StringIdentifierArgument, :config do
  RuboCop::Cop::Performance::StringIdentifierArgument::RESTRICT_ON_SEND.each do |method|
    it "registers an offense when using string argument for `#{method}` method" do
      expect_offense(<<~RUBY, method: method)
        #{method}('do_something')
        _{method} ^^^^^^^^^^^^^^ Use `:do_something` instead of `'do_something'`.
      RUBY

      expect_correction(<<~RUBY)
        #{method}(:do_something)
      RUBY
    end

    it "does not register an offense when using symbol argument for `#{method}` method" do
      expect_no_offenses(<<~RUBY)
        #{method}(:do_something)
      RUBY
    end

    it 'does not register an offense when using interpolated string argument' do
      expect_no_offenses(<<~'RUBY')
        send("do_something_#{var}")
      RUBY
    end
  end

  it 'does not register an offense when no arguments' do
    expect_no_offenses(<<~RUBY)
      send
    RUBY
  end

  it 'does not register an offense when using integer argument' do
    expect_no_offenses(<<~RUBY)
      send(42)
    RUBY
  end

  it 'does not register an offense when using symbol argument for no identifier argument' do
    expect_no_offenses(<<~RUBY)
      foo('do_something')
    RUBY
  end

  # e.g. Trunip https://github.com/jnicklas/turnip#calling-steps-from-other-steps
  it 'does not register an offense when using string argument includes spaces' do
    expect_no_offenses(<<~RUBY)
      send(':foo is :bar', foo, bar)
    RUBY
  end

  # NOTE: `attr` method is not included in this list as it can cause false positives in Nokogiri API.
  # And `attr` may not be used because `Style/Attr` registers an offense.
  # https://github.com/rubocop/rubocop-performance/issues/278
  it 'does not register an offense when using string argument for `attr` method' do
    expect_no_offenses(<<~RUBY)
      attr('foo')
    RUBY
  end
end
