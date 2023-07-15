# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Performance::StartWith, :config do
  let(:cop_config) { { 'SafeMultiline' => safe_multiline } }
  let(:safe_multiline) { true }

  shared_examples 'different match methods' do |method|
    it "registers an offense and corrects str#{method} /\\Aabc/" do
      expect_offense(<<~RUBY, method: method)
        str#{method} /\\Aabc/
        ^^^^{method}^^^^^^^^ Use `String#start_with?` instead of a regex match anchored to the beginning of the string.
      RUBY

      expect_correction(<<~RUBY)
        str.start_with?('abc')
      RUBY
    end

    it "registers an offense and corrects /\\Aabc/#{method} str" do
      expect_offense(<<~RUBY, method: method)
        /\\Aabc/#{method} str
        ^^^^^^^^^^{method}^^ Use `String#start_with?` instead of a regex match anchored to the beginning of the string.
      RUBY

      expect_correction(<<~RUBY)
        str.start_with?('abc')
      RUBY
    end

    it "registers an offense and corrects str#{method} /^abc/" do
      expect_offense(<<~RUBY, method: method)
        str#{method} /^abc/
        ^^^^{method}^^^^^^^ Use `String#start_with?` instead of a regex match anchored to the beginning of the string.
      RUBY

      expect_correction(<<~RUBY)
        str.start_with?('abc')
      RUBY
    end

    it "registers an offense and corrects /^abc/#{method} str" do
      expect_offense(<<~RUBY, method: method)
        /^abc/#{method} str
        ^^^^{method}^^^^^^^ Use `String#start_with?` instead of a regex match anchored to the beginning of the string.
      RUBY

      expect_correction(<<~RUBY)
        str.start_with?('abc')
      RUBY
    end

    # escapes like "\n"
    # note that "\b" is a literal backspace char in a double-quoted string...
    # but in a regex, it's an anchor on a word boundary
    %w[a e f r t v].each do |str|
      it "registers an offense and corrects str#{method} /\\A\\#{str}/" do
        expect_offense(<<~RUBY, method: method, str: str)
          str#{method} /\\A\\#{str}/
          ^^^^{method}^^^^^^{str}^ Use `String#start_with?` instead of a regex match anchored to the beginning of the string.
        RUBY

        expect_correction(<<~RUBY)
          str.start_with?("\\#{str}")
        RUBY
      end

      it "registers an offense and corrects /\\A\\#{str}#{method} str/" do
        expect_offense(<<~RUBY, method: method, str: str)
          /\\A\\#{str}/#{method} str
          ^^^^^{str}^^{method}^^^^ Use `String#start_with?` instead of a regex match anchored to the beginning of the string.
        RUBY

        expect_correction(<<~RUBY)
          str.start_with?("\\#{str}")
        RUBY
      end
    end

    # regexp metacharacters
    %w[. * ? $ ^ |].each do |str|
      it "registers an offense and corrects str#{method} /\\A\\#{str}/" do
        expect_offense(<<~RUBY, method: method, str: str)
          str#{method} /\\A\\#{str}/
          ^^^^{method}^^^^^^{str}^ Use `String#start_with?` instead of a regex match anchored to the beginning of the string.
        RUBY

        expect_correction(<<~RUBY)
          str.start_with?('#{str}')
        RUBY
      end

      it "registers an offense and corrects /\\A\\#{str}/#{method} str" do
        expect_offense(<<~RUBY, method: method, str: str)
          /\\A\\#{str}/#{method} str
          ^^^^^{str}^^{method}^^^^ Use `String#start_with?` instead of a regex match anchored to the beginning of the string.
        RUBY

        expect_correction(<<~RUBY)
          str.start_with?('#{str}')
        RUBY
      end

      it "doesn't register an offense for str#{method} /\\A#{str}/" do
        expect_no_offenses("str#{method} /\\A#{str}/")
      end

      it "doesn't register an offense for /\\A#{str}/#{method} str" do
        expect_no_offenses("/\\A#{str}/#{method} str")
      end
    end

    # character classes, anchors
    %w[w W s S d D A Z z G b B h H R X S].each do |str|
      it "doesn't register an offense for str#{method} /\\A\\#{str}/" do
        expect_no_offenses("str#{method} /\\A\\#{str}/")
      end

      it "doesn't register an offense for /\\A\\#{str}/#{method} str" do
        expect_no_offenses("/\\A\\#{str}/#{method} str")
      end
    end

    # characters with no special meaning whatsoever
    %w[i j l m o q y].each do |str|
      it "registers an offense and corrects str#{method} /\\A\\#{str}/" do
        expect_offense(<<~RUBY, method: method, str: str)
          str#{method} /\\A\\#{str}/
          ^^^^{method}^^^^^^{str}^ Use `String#start_with?` instead of a regex match anchored to the beginning of the string.
        RUBY

        expect_correction(<<~RUBY)
          str.start_with?('#{str}')
        RUBY
      end

      it "registers an offense and corrects /\\A\\#{str}#{method} str/" do
        expect_offense(<<~RUBY, method: method, str: str)
          /\\A\\#{str}/#{method} str
          ^^^^^{str}^^{method}^^^^ Use `String#start_with?` instead of a regex match anchored to the beginning of the string.
        RUBY

        expect_correction(<<~RUBY)
          str.start_with?('#{str}')
        RUBY
      end
    end

    it "registers an offense and corrects str#{method} /\\A\\\\/" do
      expect_offense(<<~RUBY, method: method)
        str#{method} /\\A\\\\/
        ^^^^{method}^^^^^^^ Use `String#start_with?` instead of a regex match anchored to the beginning of the string.
      RUBY

      expect_correction(<<~RUBY)
        str.start_with?('\\\\')
      RUBY
    end

    it "registers an offense and corrects /\\A\\\\/#{method} str" do
      expect_offense(<<~RUBY, method: method)
        /\\A\\\\/#{method} str
        ^^^^^^^{method}^^^^ Use `String#start_with?` instead of a regex match anchored to the beginning of the string.
      RUBY

      expect_correction(<<~RUBY)
        str.start_with?('\\\\')
      RUBY
    end
  end

  it 'registers an offense and corrects str&.match /\\Aabc/' do
    expect_offense(<<~RUBY)
      str&.match /\\Aabc/
      ^^^^^^^^^^^^^^^^^^ Use `String#start_with?` instead of a regex match anchored to the beginning of the string.
    RUBY

    expect_correction(<<~RUBY)
      str&.start_with?('abc')
    RUBY
  end

  it 'registers an offense and corrects str&.match? /\\Aabc/' do
    expect_offense(<<~RUBY)
      str&.match? /\\Aabc/
      ^^^^^^^^^^^^^^^^^^^ Use `String#start_with?` instead of a regex match anchored to the beginning of the string.
    RUBY

    expect_correction(<<~RUBY)
      str&.start_with?('abc')
    RUBY
  end

  context 'when `SafeMultiline: false`' do
    let(:safe_multiline) { false }

    include_examples('different match methods', '.match?')
    include_examples('different match methods', ' =~')
    include_examples('different match methods', '.match')

    it 'allows match without a receiver' do
      expect_no_offenses('expect(subject.spin).to match(/\A\n/)')
    end
  end

  context 'when `SafeMultiline: true`' do
    let(:safe_multiline) { true }

    it 'does not register an offense when using `^` as starting pattern' do
      expect_no_offenses(<<~RUBY)
        'abc'.match?(/^ab/)
      RUBY
    end
  end
end
