# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Performance::StringInclude, :config do
  shared_examples 'different match methods' do |method|
    it "registers an offense and corrects str#{method} /abc/" do
      expect_offense(<<~RUBY, method: method)
        str#{method} /abc/
        ^^^^{method}^^^^^^ Use `String#include?` instead of a regex match with literal-only pattern.
      RUBY

      expect_correction(<<~RUBY)
        str.include?('abc')
      RUBY
    end

    it "registers an offense and corrects /abc/#{method} str" do
      expect_offense(<<~RUBY, method: method)
        /abc/#{method} 'str'
        ^^^^^^{method}^^^^^^ Use `String#include?` instead of a regex match with literal-only pattern.
      RUBY

      expect_correction(<<~RUBY)
        'str'.include?('abc')
      RUBY
    end

    # escapes like "\n"
    # note that "\b" is a literal backspace char in a double-quoted string...
    # but in a regex, it's an anchor on a word boundary
    %w[a e f r t v].each do |str|
      it "registers an offense and corrects str#{method} /\\#{str}/" do
        expect_offense(<<~RUBY, method: method, str: str)
          str#{method} /\\#{str}/
          ^^^^{method}^^^^{str}^ Use `String#include?` instead of a regex match with literal-only pattern.
        RUBY

        expect_correction(<<~RUBY)
          str.include?("\\#{str}")
        RUBY
      end

      it "registers an offense and corrects /\\#{str}#{method} str/" do
        expect_offense(<<~RUBY, method: method, str: str)
          /\\#{str}/#{method} 'str'
          ^^^{str}^^{method}^^^^^^ Use `String#include?` instead of a regex match with literal-only pattern.
        RUBY

        expect_correction(<<~RUBY)
          'str'.include?("\\#{str}")
        RUBY
      end
    end

    # regexp metacharacters
    %w[. * ? $ ^ |].each do |str|
      it "registers an offense and corrects str#{method} /\\#{str}/" do
        expect_offense(<<~RUBY, method: method, str: str)
          str#{method} /\\#{str}/
          ^^^^{method}^^^^{str}^ Use `String#include?` instead of a regex match with literal-only pattern.
        RUBY

        expect_correction(<<~RUBY)
          str.include?('#{str}')
        RUBY
      end

      it "registers an offense and corrects /\\#{str}/#{method} str" do
        expect_offense(<<~RUBY, method: method, str: str)
          /\\#{str}/#{method} 'str'
          ^^^{str}^^{method}^^^^^^ Use `String#include?` instead of a regex match with literal-only pattern.
        RUBY

        expect_correction(<<~RUBY)
          'str'.include?('#{str}')
        RUBY
      end

      it "doesn't register an error for str#{method} /prefix#{str}/" do
        expect_no_offenses("str#{method} /prefix#{str}/")
      end

      it "doesn't register an error for /prefix#{str}/#{method} str" do
        expect_no_offenses("/prefix#{str}/#{method} str")
      end
    end

    # character classes, anchors
    %w[w W s S d D A Z z G b B h H R X S].each do |str|
      it "doesn't register an error for str#{method} /\\#{str}/" do
        expect_no_offenses("str#{method} /\\#{str}/")
      end

      it "doesn't register an error for /\\#{str}/#{method} str" do
        expect_no_offenses("/\\#{str}/#{method} str")
      end
    end

    # characters with no special meaning whatsoever
    %w[i j l m o q y].each do |str|
      it "registers an offense and corrects str#{method} /\\#{str}/" do
        expect_offense(<<~RUBY, method: method, str: str)
          str#{method} /\\#{str}/
          ^^^^{method}^^^^{str}^ Use `String#include?` instead of a regex match with literal-only pattern.
        RUBY

        expect_correction(<<~RUBY)
          str.include?('#{str}')
        RUBY
      end

      it "registers an offense and corrects /\\#{str}#{method} str/" do
        expect_offense(<<~RUBY, method: method, str: str)
          /\\#{str}/#{method} 'str'
          ^^^{str}^{method}^^^^^^^ Use `String#include?` instead of a regex match with literal-only pattern.
        RUBY

        expect_correction(<<~RUBY)
          'str'.include?('#{str}')
        RUBY
      end
    end

    it "registers an offense and corrects str#{method} /\\\\/" do
      expect_offense(<<~RUBY, method: method)
        str#{method} /\\\\/
        ^^^^{method}^^^^^ Use `String#include?` instead of a regex match with literal-only pattern.
      RUBY

      expect_correction(<<~RUBY)
        str.include?('\\\\')
      RUBY
    end

    it "registers an offense and corrects /\\\\/#{method} str" do
      expect_offense(<<~RUBY, method: method)
        /\\\\/#{method} 'str'
        ^^^^^{method}^^^^^^ Use `String#include?` instead of a regex match with literal-only pattern.
      RUBY

      expect_correction(<<~RUBY)
        'str'.include?('\\\\')
      RUBY
    end
  end

  include_examples('different match methods', '.match?')
  include_examples('different match methods', ' =~')
  include_examples('different match methods', '.match')

  it 'allows match without a receiver' do
    expect_no_offenses('expect(subject.spin).to match(/\A\n/)')
  end

  it 'registers an offense and corrects when argument of `match?` is not a string literal' do
    expect_offense(<<~RUBY)
      / /.match?(content)
      ^^^^^^^^^^^^^^^^^^^ Use `String#include?` instead of a regex match with literal-only pattern.
    RUBY
  end

  it 'registers an offense and corrects when using `!~`' do
    expect_offense(<<~RUBY)
      str !~ /abc/
      ^^^^^^^^^^^^ Use `!String#include?` instead of a regex match with literal-only pattern.
    RUBY

    expect_correction(<<~RUBY)
      !str.include?('abc')
    RUBY
  end
end
