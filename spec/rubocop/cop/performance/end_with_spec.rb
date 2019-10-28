# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Performance::EndWith do
  subject(:cop) { described_class.new }

  shared_examples 'different match methods' do |method|
    it "autocorrects str#{method} /abc\\z/" do
      new_source = autocorrect_source("str#{method} /abc\\z/")
      expect(new_source).to eq "str.end_with?('abc')"
    end

    it "autocorrects /abc\\z/#{method} str" do
      new_source = autocorrect_source("/abc\\z/#{method} str")
      expect(new_source).to eq "str.end_with?('abc')"
    end

    it "autocorrects str#{method} /\\n\\z/" do
      new_source = autocorrect_source("str#{method} /\\n\\z/")
      expect(new_source).to eq 'str.end_with?("\n")'
    end

    it "autocorrects /\\n\\z/#{method} str" do
      new_source = autocorrect_source("/\\n\\z/#{method} str")
      expect(new_source).to eq 'str.end_with?("\n")'
    end

    it "autocorrects str#{method} /\\t\\z/" do
      new_source = autocorrect_source("str#{method} /\\t\\z/")
      expect(new_source).to eq 'str.end_with?("\t")'
    end

    it "autocorrects /\\t\\z/#{method} str" do
      new_source = autocorrect_source("/\\t\\z/#{method} str")
      expect(new_source).to eq 'str.end_with?("\t")'
    end

    # regexp metacharacters
    %w[. $ ^ |].each do |str|
      it "autocorrects str#{method} /\\#{str}\\z/" do
        new_source = autocorrect_source("str#{method} /\\#{str}\\z/")
        expect(new_source).to eq "str.end_with?('#{str}')"
      end

      it "autocorrects /\\#{str}\\z/#{method} str" do
        new_source = autocorrect_source("/\\#{str}\\z/#{method} str")
        expect(new_source).to eq "str.end_with?('#{str}')"
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
      it "autocorrects str#{method} /\\#{str}\\z/" do
        new_source = autocorrect_source("str#{method} /\\#{str}\\z/")
        expect(new_source).to eq %{str.end_with?("\\#{str}")}
      end

      it "autocorrects /\\#{str}\\z/#{method} str" do
        new_source = autocorrect_source("/\\#{str}\\z/#{method} str")
        expect(new_source).to eq %{str.end_with?("\\#{str}")}
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
      it "autocorrects str#{method} /\\#{str}\\z/" do
        new_source = autocorrect_source("str#{method} /\\#{str}\\z/")
        expect(new_source).to eq "str.end_with?('#{str}')"
      end

      it "autocorrects /\\#{str}\\z/#{method} str" do
        new_source = autocorrect_source("/\\#{str}\\z/#{method} str")
        expect(new_source).to eq "str.end_with?('#{str}')"
      end
    end

    it "formats the error message correctly for str#{method} /abc\\z/" do
      inspect_source("str#{method} /abc\\z/")
      expect(cop.messages).to eq(['Use `String#end_with?` instead of a ' \
                                  'regex match anchored to the end of ' \
                                  'the string.'])
    end

    it "formats the error message correctly for /abc\\z/#{method} str" do
      inspect_source("/abc\\z/#{method} str")
      expect(cop.messages).to eq(['Use `String#end_with?` instead of a ' \
                                  'regex match anchored to the end of ' \
                                  'the string.'])
    end

    it "autocorrects str#{method} /\\\\\\z/" do
      new_source = autocorrect_source("str#{method} /\\\\\\z/")
      expect(new_source).to eq("str.end_with?('\\\\')")
    end

    it "autocorrects /\\\\\\z/#{method} str" do
      new_source = autocorrect_source("/\\\\\\z/#{method} str")
      expect(new_source).to eq("str.end_with?('\\\\')")
    end
  end

  include_examples('different match methods', '.match?')
  include_examples('different match methods', ' =~')
  include_examples('different match methods', '.match')

  it 'allows match without a receiver' do
    expect_no_offenses('expect(subject.spin).to match(/\n\z/)')
  end
end
