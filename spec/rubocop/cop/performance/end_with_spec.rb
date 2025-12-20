# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Performance::EndWith, :config do
  let(:cop_config) { { 'SafeMultiline' => safe_multiline } }
  let(:safe_multiline) { true }

  shared_examples 'different match methods' do |method|
    it "registers an offense and corrects str#{method} /abc\\z/" do
      expect_offense(<<~RUBY, method: method)
        str#{method} /abc\\z/
        ^^^^{method}^^^^^^^^ Use `String#end_with?` instead of a regex match anchored to the end of the string.
      RUBY

      expect_correction(<<~RUBY)
        str.end_with?('abc')
      RUBY
    end

    it "registers an offense and corrects /abc\\z/#{method} str" do
      expect_offense(<<~RUBY, method: method)
        /abc\\z/#{method} str
        ^^^^^^^^{method}^^^^ Use `String#end_with?` instead of a regex match anchored to the end of the string.
      RUBY

      expect_correction(<<~RUBY)
        str.end_with?('abc')
      RUBY
    end

    it "registers an offense and corrects str#{method} /abc$/" do
      expect_offense(<<~RUBY, method: method)
        str#{method} /abc$/
        ^^^^{method}^^^^^^^ Use `String#end_with?` instead of a regex match anchored to the end of the string.
      RUBY

      expect_correction(<<~RUBY)
        str.end_with?('abc')
      RUBY
    end

    it "registers an offense and corrects /abc$/#{method} str" do
      expect_offense(<<~RUBY, method: method)
        /abc$/#{method} str
        ^^^^^^{method}^^^^^ Use `String#end_with?` instead of a regex match anchored to the end of the string.
      RUBY

      expect_correction(<<~RUBY)
        str.end_with?('abc')
      RUBY
    end

    it "registers an offense and corrects str#{method} /\\n\\z/" do
      expect_offense(<<~RUBY, method: method)
        str#{method} /\\n\\z/
        ^^^^{method}^^^^^^^ Use `String#end_with?` instead of a regex match anchored to the end of the string.
      RUBY

      expect_correction(<<~RUBY)
        str.end_with?("\\n")
      RUBY
    end

    it "registers an offense and corrects /\\n\\z/#{method} str" do
      expect_offense(<<~RUBY, method: method)
        /\\n\\z/#{method} str
        ^^^^^^^{method}^^^^ Use `String#end_with?` instead of a regex match anchored to the end of the string.
      RUBY

      expect_correction(<<~RUBY)
        str.end_with?("\\n")
      RUBY
    end

    it "registers an offense and corrects str#{method} /\\t\\z/" do
      expect_offense(<<~RUBY, method: method)
        str#{method} /\\t\\z/
        ^^^^{method}^^^^^^^ Use `String#end_with?` instead of a regex match anchored to the end of the string.
      RUBY

      expect_correction(<<~RUBY)
        str.end_with?("\\t")
      RUBY
    end

    it "registers an offense and corrects /\\t\\z/#{method} str" do
      expect_offense(<<~RUBY, method: method)
        /\\t\\z/#{method} str
        ^^^^^^^{method}^^^^ Use `String#end_with?` instead of a regex match anchored to the end of the string.
      RUBY

      expect_correction(<<~RUBY)
        str.end_with?("\\t")
      RUBY
    end

    # regexp metacharacters
    %w[. $ ^ |].each do |str|
      it "registers an offense and corrects str#{method} /\\#{str}\\z/" do
        expect_offense(<<~RUBY, method: method, str: str)
          str#{method} /\\#{str}\\z/
          ^^^^{method}^^^^{str}^^^ Use `String#end_with?` instead of a regex match anchored to the end of the string.
        RUBY

        expect_correction(<<~RUBY)
          str.end_with?('#{str}')
        RUBY
      end

      it "registers an offense and corrects /\\#{str}\\z/#{method} str" do
        expect_offense(<<~RUBY, method: method, str: str)
          /\\#{str}\\z/#{method} str
          ^^^{str}^^^^{method}^^^^ Use `String#end_with?` instead of a regex match anchored to the end of the string.
        RUBY

        expect_correction(<<~RUBY)
          str.end_with?('#{str}')
        RUBY
      end

      it "doesn't register an error for str#{method} /#{str}\\z/" do
        expect_no_offenses("str#{method} /#{str}\\z/")
      end

      it "doesn't register an error for /#{str}\\z/#{method} str" do
        expect_no_offenses("/#{str}\\z/#{method} str")
      end
    end

    # escapes like "\n"
    # note that "\b" is a literal backspace char in a double-quoted string...
    # but in a regex, it's an anchor on a word boundary
    %w[a e f r t v].each do |str|
      it "registers an offense and corrects str#{method} /\\#{str}\\z/" do
        expect_offense(<<~RUBY, method: method, str: str)
          str#{method} /\\#{str}\\z/
          ^^^^{method}^^^^{str}^^^ Use `String#end_with?` instead of a regex match anchored to the end of the string.
        RUBY

        expect_correction(<<~RUBY)
          str.end_with?("\\#{str}")
        RUBY
      end

      it "registers an offense and corrects /\\#{str}\\z/#{method} str" do
        expect_offense(<<~RUBY, method: method, str: str)
          /\\#{str}\\z/#{method} str
          ^^^{str}^^^^{method}^^^^ Use `String#end_with?` instead of a regex match anchored to the end of the string.
        RUBY

        expect_correction(<<~RUBY)
          str.end_with?("\\#{str}")
        RUBY
      end
    end

    # character classes, anchors
    %w[w W s S d D A Z z G b B h H R X S].each do |str|
      it "doesn't register an error for str#{method} /\\#{str}\\z/" do
        expect_no_offenses("str#{method} /\\#{str}\\z/")
      end

      it "doesn't register an error for /\\#{str}\\z/#{method} str" do
        expect_no_offenses("/\\#{str}\\z/#{method} str")
      end
    end

    # characters with no special meaning whatsoever
    %w[i j l m o q y].each do |str|
      it "registers an offense and corrects str#{method} /\\#{str}\\z/" do
        expect_offense(<<~RUBY, method: method, str: str)
          str#{method} /\\#{str}\\z/
          ^^^^{method}^^^^{str}^^^ Use `String#end_with?` instead of a regex match anchored to the end of the string.
        RUBY

        expect_correction(<<~RUBY)
          str.end_with?('#{str}')
        RUBY
      end

      it "registers an offense and corrects /\\#{str}\\z/#{method} str" do
        expect_offense(<<~RUBY, method: method, str: str)
          /\\#{str}\\z/#{method} str
          ^^^{str}^^^^{method}^^^^ Use `String#end_with?` instead of a regex match anchored to the end of the string.
        RUBY

        expect_correction(<<~RUBY)
          str.end_with?('#{str}')
        RUBY
      end
    end

    it "registers an offense and corrects str#{method} /\\\\\\z/" do
      expect_offense(<<~RUBY, method: method)
        str#{method} /\\\\\\z/
        ^^^^{method}^^^^^^^ Use `String#end_with?` instead of a regex match anchored to the end of the string.
      RUBY

      expect_correction(<<~RUBY)
        str.end_with?('\\\\')
      RUBY
    end

    it "registers an offense and corrects /\\\\\\z/#{method} str" do
      expect_offense(<<~RUBY, method: method)
        /\\\\\\z/#{method} str
        ^^^^^^^{method}^^^^ Use `String#end_with?` instead of a regex match anchored to the end of the string.
      RUBY

      expect_correction(<<~RUBY)
        str.end_with?('\\\\')
      RUBY
    end
  end

  it 'registers an offense and corrects str&.match /abc\\z/' do
    expect_offense(<<~RUBY)
      str&.match /abc\\z/
      ^^^^^^^^^^^^^^^^^^ Use `String#end_with?` instead of a regex match anchored to the end of the string.
    RUBY

    expect_correction(<<~RUBY)
      str&.end_with?('abc')
    RUBY
  end

  it 'registers an offense and corrects str&.match? /abc\\z/' do
    expect_offense(<<~RUBY)
      str&.match? /abc\\z/
      ^^^^^^^^^^^^^^^^^^^ Use `String#end_with?` instead of a regex match anchored to the end of the string.
    RUBY

    expect_correction(<<~RUBY)
      str&.end_with?('abc')
    RUBY
  end

  context 'when `SafeMultiline: false`' do
    let(:safe_multiline) { false }

    it_behaves_like('different match methods', '.match?')
    it_behaves_like('different match methods', ' =~')
    it_behaves_like('different match methods', '.match')

    it 'allows match without a receiver' do
      expect_no_offenses('expect(subject.spin).to match(/\n\z/)')
    end
  end

  context 'when `SafeMultiline: true`' do
    let(:safe_multiline) { true }

    it 'does not register an offense using `$` as ending pattern' do
      expect_no_offenses(<<~RUBY)
        'abc'.match?(/ab$/)
      RUBY
    end
  end
end
