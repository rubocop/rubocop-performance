# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Performance::StringBytesize, :config do
  let(:msg) { 'Use `String#bytesize` instead of calculating the size of the bytes array.' }

  it 'registers an offense with `size` method' do
    expect_offense(<<~RUBY)
      string.bytes.size
             ^^^^^^^^^^ #{msg}
    RUBY

    expect_correction(<<~RUBY)
      string.bytesize
    RUBY
  end

  it 'registers an offense with `length` method' do
    expect_offense(<<~RUBY)
      string.bytes.length
             ^^^^^^^^^^^^ #{msg}
    RUBY

    expect_correction(<<~RUBY)
      string.bytesize
    RUBY
  end

  it 'registers an offense with `count` method' do
    expect_offense(<<~RUBY)
      string.bytes.count
             ^^^^^^^^^^^ #{msg}
    RUBY

    expect_correction(<<~RUBY)
      string.bytesize
    RUBY
  end

  it 'registers an offense with string literal' do
    expect_offense(<<~RUBY)
      "foobar".bytes.count
               ^^^^^^^^^^^ #{msg}
    RUBY

    expect_correction(<<~RUBY)
      "foobar".bytesize
    RUBY
  end

  it 'registers an offense and autocorrects with safe navigation' do
    expect_offense(<<~RUBY)
      string&.bytes&.count
              ^^^^^^^^^^^^ #{msg}
    RUBY

    expect_correction(<<~RUBY)
      string&.bytesize
    RUBY
  end

  it 'registers an offense and autocorrects with partial safe navigation' do
    expect_offense(<<~RUBY)
      string&.bytes.count
              ^^^^^^^^^^^ #{msg}
    RUBY

    expect_correction(<<~RUBY)
      string&.bytesize
    RUBY
  end

  it 'does not register an offense without array size method' do
    expect_no_offenses(<<~RUBY)
      string.bytes
    RUBY
  end

  it 'does not register an offense with `bytes` without explicit receiver' do
    expect_no_offenses(<<~RUBY)
      bytes.size
    RUBY
  end

  it 'does not register an offense when the receiver is of type `int`' do
    expect_no_offenses(<<~RUBY)
      3.bytes.size
    RUBY
  end
end
