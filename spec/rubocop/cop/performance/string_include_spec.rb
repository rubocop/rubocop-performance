# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Performance::StringInclude do
  subject(:cop) { described_class.new }

  shared_examples 'different match methods' do |method|
    it "autocorrects str#{method} /abc/" do
      new_source = autocorrect_source("str#{method} /abc/")
      expect(new_source).to eq "str.include?('abc')"
    end

    it "autocorrects /abc/#{method} str" do
      new_source = autocorrect_source("/abc/#{method} str")
      expect(new_source).to eq "str.include?('abc')"
    end

    # escapes like "\n"
    # note that "\b" is a literal backspace char in a double-quoted string...
    # but in a regex, it's an anchor on a word boundary
    %w[a e f r t v].each do |str|
      it "autocorrects str#{method} /\\#{str}/" do
        new_source = autocorrect_source("str#{method} /\\#{str}/")
        expect(new_source).to eq %{str.include?("\\#{str}")}
      end

      it "autocorrects /\\#{str}#{method} str/" do
        new_source = autocorrect_source("/\\#{str}/#{method} str")
        expect(new_source).to eq %{str.include?("\\#{str}")}
      end
    end

    # regexp metacharacters
    %w[. * ? $ ^ |].each do |str|
      it "autocorrects str#{method} /\\#{str}/" do
        new_source = autocorrect_source("str#{method} /\\#{str}/")
        expect(new_source).to eq "str.include?('#{str}')"
      end

      it "autocorrects /\\#{str}/#{method} str" do
        new_source = autocorrect_source("/\\#{str}/#{method} str")
        expect(new_source).to eq "str.include?('#{str}')"
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
      it "autocorrects str#{method} /\\#{str}/" do
        new_source = autocorrect_source("str#{method} /\\#{str}/")
        expect(new_source).to eq "str.include?('#{str}')"
      end

      it "autocorrects /\\#{str}#{method} str/" do
        new_source = autocorrect_source("/\\#{str}/#{method} str")
        expect(new_source).to eq "str.include?('#{str}')"
      end
    end

    it "formats the error message correctly for str#{method} /abc/" do
      inspect_source("str#{method} /abc/")
      expect(cop.messages).to eq(['Use `String#include?` instead of a regex match with literal-only pattern.'])
    end

    it "formats the error message correctly for /abc/#{method} str" do
      inspect_source("/abc/#{method} str")
      expect(cop.messages).to eq(['Use `String#include?` instead of a regex match with literal-only pattern.'])
    end

    it "autocorrects str#{method} /\\\\/" do
      new_source = autocorrect_source("str#{method} /\\\\/")
      expect(new_source).to eq("str.include?('\\\\')")
    end

    it "autocorrects /\\\\/#{method} str" do
      new_source = autocorrect_source("/\\\\/#{method} str")
      expect(new_source).to eq("str.include?('\\\\')")
    end
  end

  include_examples('different match methods', '.match?')
  include_examples('different match methods', ' =~')
  include_examples('different match methods', '.match')

  it 'allows match without a receiver' do
    expect_no_offenses('expect(subject.spin).to match(/\A\n/)')
  end
end
