# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Performance::RedundantSplitRegexpArgument do
  subject(:cop) { described_class.new }

  it 'accepts methods other than split' do
    expect_no_offenses("'a,b,c'.insert(2, 'a')")
  end

  it 'accepts when split does not receive a regexp' do
    expect_no_offenses("'a,b,c'.split(',')")
  end

  it 'accepts when split does not receive a deterministic regexp' do
    expect_no_offenses("'a,b,c'.split(/,+/)")
  end

  it 'registers an offense when the method is split and correctly removes escaping characters' do
    expect_offense(<<~RUBY)
      'a,b,c'.split(/\\./)
                    ^^^^ Use string as argument instead of regexp.
    RUBY

    expect_correction(<<~RUBY)
      'a,b,c'.split(".")
    RUBY
  end

  it 'registers an offense when the method is split and corrects correctly special string chars' do
    expect_offense(<<~RUBY)
      "foo\\nbar\\nbaz\\n".split(/\\n/)
                              ^^^^ Use string as argument instead of regexp.
    RUBY

    expect_correction(<<~RUBY)
      "foo\\nbar\\nbaz\\n".split("\\n")
    RUBY
  end

  it 'registers an offense when the method is split' do
    expect_offense(<<~RUBY)
      'a,b,c'.split(/,/)
                    ^^^ Use string as argument instead of regexp.
    RUBY

    expect_correction(<<~RUBY)
      'a,b,c'.split(",")
    RUBY
  end
end
