# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Performance::RedundantStringChars do
  subject(:cop) { described_class.new }

  it 'registers an offense and corrects when using `str.chars[0..2]`' do
    expect_offense(<<~RUBY)
      str.chars[0..2]
          ^^^^^^^^^^^ Use `[0..2].chars` instead of `chars[0..2]`.
    RUBY

    expect_correction(<<~RUBY)
      str[0..2].chars
    RUBY
  end

  it 'registers an offense and corrects when using `str.chars.slice(0..2)`' do
    expect_offense(<<~RUBY)
      str.chars.slice(0..2)
          ^^^^^^^^^^^^^^^^^ Use `[0..2].chars` instead of `chars.slice(0..2)`.
    RUBY

    expect_correction(<<~RUBY)
      str[0..2].chars
    RUBY
  end

  it 'registers an offense and corrects when using `str.chars.first`' do
    expect_offense(<<~RUBY)
      str.chars.first
          ^^^^^^^^^^^ Use `[0]` instead of `chars.first`.
    RUBY

    expect_correction(<<~RUBY)
      str[0]
    RUBY
  end

  it 'registers an offense and corrects when using `str.chars.first(2)`' do
    expect_offense(<<~RUBY)
      str.chars.first(2)
          ^^^^^^^^^^^^^^ Use `[0...2].chars` instead of `chars.first(2)`.
    RUBY

    expect_correction(<<~RUBY)
      str[0...2].chars
    RUBY
  end

  it 'registers an offense and corrects when using `str.chars.last`' do
    expect_offense(<<~RUBY)
      str.chars.last
          ^^^^^^^^^^ Use `[-1]` instead of `chars.last`.
    RUBY

    expect_correction(<<~RUBY)
      str[-1]
    RUBY
  end

  it 'registers an offense and corrects when using `str.chars.last(2)`' do
    expect_offense(<<~RUBY)
      str.chars.last(2)
          ^^^^^^^^^^^^^ Use `[-2..-1].chars` instead of `chars.last(2)`.
    RUBY

    expect_correction(<<~RUBY)
      str[-2..-1].chars
    RUBY
  end

  it 'registers an offense and corrects when using `str.chars.take(2)`' do
    expect_offense(<<~RUBY)
      str.chars.take(2)
          ^^^^^^^^^^^^^ Use `[0...2].chars` instead of `chars.take(2)`.
    RUBY

    expect_correction(<<~RUBY)
      str[0...2].chars
    RUBY
  end

  it 'registers an offense and corrects when using `str.chars.drop(2)`' do
    expect_offense(<<~RUBY)
      str.chars.drop(2)
          ^^^^^^^^^^^^^ Use `[2..-1].chars` instead of `chars.drop(2)`.
    RUBY

    expect_correction(<<~RUBY)
      str[2..-1].chars
    RUBY
  end

  it 'registers an offense and corrects when using `str.chars.length`' do
    expect_offense(<<~RUBY)
      str.chars.length
          ^^^^^^^^^^^^ Use `.length` instead of `chars.length`.
    RUBY

    expect_correction(<<~RUBY)
      str.length
    RUBY
  end

  it 'registers an offense and corrects when using `str.chars.size`' do
    expect_offense(<<~RUBY)
      str.chars.size
          ^^^^^^^^^^ Use `.size` instead of `chars.size`.
    RUBY

    expect_correction(<<~RUBY)
      str.size
    RUBY
  end

  it 'registers an offense and corrects when using `str.chars.empty?`' do
    expect_offense(<<~RUBY)
      str.chars.empty?
          ^^^^^^^^^^^^ Use `.empty?` instead of `chars.empty?`.
    RUBY

    expect_correction(<<~RUBY)
      str.empty?
    RUBY
  end

  it 'does not register an offense when using `str.chars.max`' do
    expect_no_offenses(<<~RUBY)
      str.chars.max
    RUBY
  end
end
