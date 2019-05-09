# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Performance::UnfreezeString, :config do
  subject(:cop) { described_class.new(config) }

  context 'TargetRubyVersion >= 2.3', :ruby23 do
    it 'registers an offense for an empty string with `.dup`' do
      expect_offense(<<~RUBY)
        "".dup
        ^^^^^^ Use unary plus to get an unfrozen string literal.
      RUBY
    end

    it 'registers an offense for a string with `.dup`' do
      expect_offense(<<~RUBY)
        "foo".dup
        ^^^^^^^^^ Use unary plus to get an unfrozen string literal.
      RUBY
    end

    it 'registers an offense for a heredoc with `.dup`' do
      expect_offense(<<~RUBY)
        <<TEXT.dup
        ^^^^^^^^^^ Use unary plus to get an unfrozen string literal.
          foo
          bar
        TEXT
      RUBY
    end

    it 'registers an offense for a string that contains a string' \
       'interpolation with `.dup`' do
      expect_offense(<<~'RUBY')
        "foo#{bar}baz".dup
        ^^^^^^^^^^^^^^^^^^ Use unary plus to get an unfrozen string literal.
      RUBY
    end

    it 'registers an offense for `String.new`' do
      expect_offense(<<~RUBY)
        String.new
        ^^^^^^^^^^ Use unary plus to get an unfrozen string literal.
      RUBY
    end

    it 'registers an offense for `String.new` with an empty string' do
      expect_offense(<<~RUBY)
        String.new('')
        ^^^^^^^^^^^^^^ Use unary plus to get an unfrozen string literal.
      RUBY
    end

    it 'registers an offense for `String.new` with a string' do
      expect_offense(<<~RUBY)
        String.new('foo')
        ^^^^^^^^^^^^^^^^^ Use unary plus to get an unfrozen string literal.
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
  end
end
