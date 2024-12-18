# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Performance::Squeeze, :config do
  it "registers an offense and corrects when using `#gsub(/a+/, 'a')`" do
    expect_offense(<<~RUBY)
      str.gsub(/a+/, 'a')
          ^^^^ Use `squeeze` instead of `gsub`.
    RUBY

    expect_correction(<<~RUBY)
      str.squeeze('a')
    RUBY
  end

  it "registers an offense and corrects when using `#gsub(/a+/, 'a')` with safe navigation operator" do
    expect_offense(<<~RUBY)
      str&.gsub(/a+/, 'a')
           ^^^^ Use `squeeze` instead of `gsub`.
    RUBY

    expect_correction(<<~RUBY)
      str&.squeeze('a')
    RUBY
  end

  it "registers an offense and corrects when using `#gsub!(/a+/, 'a')`" do
    expect_offense(<<~RUBY)
      str.gsub!(/a+/, 'a')
          ^^^^^ Use `squeeze!` instead of `gsub!`.
    RUBY

    expect_correction(<<~RUBY)
      str.squeeze!('a')
    RUBY
  end

  it 'does not register an offense when using `#squeeze`' do
    expect_no_offenses(<<~RUBY)
      str.squeeze('a')
    RUBY
  end

  it 'does not register an offense when using `#squeeze!`' do
    expect_no_offenses(<<~RUBY)
      str.squeeze!('a')
    RUBY
  end

  it 'does not register an offense when replacement does not match pattern' do
    expect_no_offenses(<<~RUBY)
      str.gsub(/a+/, 'b')
    RUBY
  end

  it 'registers an offense when AST string literal might be frozen' do
    expect_offense(<<~'RUBY')
      str.gsub(/\n+/, ?\n)
          ^^^^ Use `squeeze` instead of `gsub`.
    RUBY

    expect_correction(<<~'RUBY')
      str.squeeze("\n")
    RUBY
  end
end
