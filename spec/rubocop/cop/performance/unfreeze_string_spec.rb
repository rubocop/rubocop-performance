# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Performance::UnfreezeString, :config do
  context 'when Ruby >= 3.3', :ruby33 do
    it 'does not register an offense for an empty string with `.dup`' do
      expect_no_offenses(<<~RUBY)
        "".dup
      RUBY
    end
  end

  context 'when Ruby <= 3.2', :ruby32, unsupported_on: :prism do
    it 'registers an offense and corrects for an empty string with `.dup`' do
      expect_offense(<<~RUBY)
        "".dup
        ^^^^^^ Use unary plus to get an unfrozen string literal.
      RUBY

      expect_correction(<<~RUBY)
        +""
      RUBY
    end

    it 'registers an offense and corrects for a string with `.dup`' do
      expect_offense(<<~RUBY)
        "foo".dup
        ^^^^^^^^^ Use unary plus to get an unfrozen string literal.
      RUBY

      expect_correction(<<~RUBY)
        +"foo"
      RUBY
    end

    it 'registers an offense and corrects for a heredoc with `.dup`' do
      expect_offense(<<~RUBY)
        <<TEXT.dup
        ^^^^^^^^^^ Use unary plus to get an unfrozen string literal.
          foo
          bar
        TEXT
      RUBY

      expect_correction(<<~RUBY)
        +<<TEXT
          foo
          bar
        TEXT
      RUBY
    end

    it 'registers an offense and corrects for a string that contains a stringinterpolation with `.dup`' do
      expect_offense(<<~'RUBY')
        "foo#{bar}baz".dup
        ^^^^^^^^^^^^^^^^^^ Use unary plus to get an unfrozen string literal.
      RUBY

      expect_correction(<<~'RUBY')
        +"foo#{bar}baz"
      RUBY
    end
  end

  it 'registers an offense and corrects for `String.new`' do
    expect_offense(<<~RUBY)
      String.new
      ^^^^^^^^^^ Use unary plus to get an unfrozen string literal.
    RUBY

    expect_correction(<<~RUBY)
      +''
    RUBY
  end

  it 'registers an offense and corrects for `String.new` with an empty string' do
    expect_offense(<<~RUBY)
      String.new('')
      ^^^^^^^^^^^^^^ Use unary plus to get an unfrozen string literal.
    RUBY

    expect_correction(<<~RUBY)
      +''
    RUBY
  end

  it 'registers an offense and corrects for `String.new` with a string' do
    expect_offense(<<~RUBY)
      String.new('foo')
      ^^^^^^^^^^^^^^^^^ Use unary plus to get an unfrozen string literal.
    RUBY

    expect_correction(<<~RUBY)
      +'foo'
    RUBY
  end

  it 'registers an offense and corrects when invoking a method after `String.new` with a string' do
    expect_offense(<<~RUBY)
      String.new('foo').force_encoding(Encoding::ASCII)
      ^^^^^^^^^^^^^^^^^ Use unary plus to get an unfrozen string literal.
    RUBY

    expect_correction(<<~RUBY)
      (+'foo').force_encoding(Encoding::ASCII)
    RUBY
  end

  it 'accepts an empty string with unary plus operator' do
    expect_no_offenses(<<~RUBY)
      +""
    RUBY
  end

  it 'accepts a string with unary plus operator' do
    expect_no_offenses(<<~RUBY)
      +"foobar"
    RUBY
  end

  it 'accepts `String.new` with capacity option' do
    expect_no_offenses(<<~RUBY)
      String.new(capacity: 100)
    RUBY
  end

  context 'when Ruby <= 2.2', :ruby22, unsupported_on: :prism do
    it 'does not register an offense for an empty string with `.dup`' do
      expect_no_offenses(<<~RUBY)
        "".dup
      RUBY
    end
  end
end
