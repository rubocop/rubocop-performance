# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Performance::StartWith do
  subject(:cop) { described_class.new }

  shared_examples 'different match methods' do |method|
    it "autocorrects str#{method} /\\Aabc/" do
      new_source = autocorrect_source("str#{method} /\\Aabc/")
      expect(new_source).to eq "str.start_with?('abc')"
    end

    it "autocorrects /\\Aabc/#{method} str" do
      new_source = autocorrect_source("/\\Aabc/#{method} str")
      expect(new_source).to eq "str.start_with?('abc')"
    end

    # escapes like "\n"
    # note that "\b" is a literal backspace char in a double-quoted string...
    # but in a regex, it's an anchor on a word boundary
    %w[a e f r t v].each do |str|
      it "autocorrects str#{method} /\\A\\#{str}/" do
        new_source = autocorrect_source("str#{method} /\\A\\#{str}/")
        expect(new_source).to eq %{str.start_with?("\\#{str}")}
      end

      it "autocorrects /\\A\\#{str}#{method} str/" do
        new_source = autocorrect_source("/\\A\\#{str}/#{method} str")
        expect(new_source).to eq %{str.start_with?("\\#{str}")}
      end
    end

    # regexp metacharacters
    %w[. * ? $ ^ |].each do |str|
      it "autocorrects str#{method} /\\A\\#{str}/" do
        new_source = autocorrect_source("str#{method} /\\A\\#{str}/")
        expect(new_source).to eq "str.start_with?('#{str}')"
      end

      it "autocorrects /\\A\\#{str}/#{method} str" do
        new_source = autocorrect_source("/\\A\\#{str}/#{method} str")
        expect(new_source).to eq "str.start_with?('#{str}')"
      end

      it "doesn't register an error for str#{method} /\\A#{str}/" do
        expect_no_offenses("str#{method} /\\A#{str}/")
      end

      it "doesn't register an error for /\\A#{str}/#{method} str" do
        expect_no_offenses("/\\A#{str}/#{method} str")
      end
    end

    # character classes, anchors
    %w[w W s S d D A Z z G b B h H R X S].each do |str|
      it "doesn't register an error for str#{method} /\\A\\#{str}/" do
        expect_no_offenses("str#{method} /\\A\\#{str}/")
      end

      it "doesn't register an error for /\\A\\#{str}/#{method} str" do
        expect_no_offenses("/\\A\\#{str}/#{method} str")
      end
    end

    # characters with no special meaning whatsoever
    %w[i j l m o q y].each do |str|
      it "autocorrects str#{method} /\\A\\#{str}/" do
        new_source = autocorrect_source("str#{method} /\\A\\#{str}/")
        expect(new_source).to eq "str.start_with?('#{str}')"
      end

      it "autocorrects /\\A\\#{str}#{method} str/" do
        new_source = autocorrect_source("/\\A\\#{str}/#{method} str")
        expect(new_source).to eq "str.start_with?('#{str}')"
      end
    end

    it "formats the error message correctly for str#{method} /\\Aabc/" do
      inspect_source("str#{method} /\\Aabc/")
      expect(cop.messages).to eq(['Use `String#start_with?` instead of a ' \
                                  'regex match anchored to the beginning of ' \
                                  'the string.'])
    end

    it "formats the error message correctly for /\\Aabc/#{method} str" do
      inspect_source("/\\Aabc/#{method} str")
      expect(cop.messages).to eq(['Use `String#start_with?` instead of a ' \
                                  'regex match anchored to the beginning of ' \
                                  'the string.'])
    end

    it "autocorrects str#{method} /\\A\\\\/" do
      new_source = autocorrect_source("str#{method} /\\A\\\\/")
      expect(new_source).to eq("str.start_with?('\\\\')")
    end

    it "autocorrects /\\A\\\\/#{method} str" do
      new_source = autocorrect_source("/\\A\\\\/#{method} str")
      expect(new_source).to eq("str.start_with?('\\\\')")
    end
  end

  include_examples('different match methods', '.match?')
  include_examples('different match methods', ' =~')
  include_examples('different match methods', '.match')

  it 'allows match without a receiver' do
    expect_no_offenses('expect(subject.spin).to match(/\A\n/)')
  end
end
