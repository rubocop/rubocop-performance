# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Performance::RedundantSplitRegexpArgument, :config do
  it 'accepts methods other than split' do
    expect_no_offenses("'a,b,c'.insert(2, 'a')")
  end

  it 'accepts when split does not receive a regexp' do
    expect_no_offenses("'a,b,c'.split(',')")
  end

  it 'accepts when split does not receive a deterministic regexp' do
    expect_no_offenses("'a,b,c'.split(/,+/)")
  end

  it 'accepts when using split method with ignorecase regexp option' do
    expect_no_offenses("'fooSplitbar'.split(/split/i)")
  end

  it 'accepts when `split` method argument is exactly one spece regexp `/ /`' do
    expect_no_offenses(<<~RUBY)
      'foo         bar'.split(/ /)
    RUBY
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

  it 'registers an offense when the method is split and corrects correctly consecutive special string chars' do
    expect_offense(<<~RUBY)
      "foo\\n\\nbar\\n\\nbaz\\n\\n".split(/\\n\\n/)
                                    ^^^^^^ Use string as argument instead of regexp.
    RUBY

    expect_correction(<<~RUBY)
      "foo\\n\\nbar\\n\\nbaz\\n\\n".split("\\n\\n")
    RUBY
  end

  it 'registers an offense when the method is split and corrects correctly consecutive backslash escape chars' do
    expect_offense(<<~RUBY)
      "foo\\\\\\.bar".split(/\\\\\\./)
                         ^^^^^^ Use string as argument instead of regexp.
    RUBY

    expect_correction(<<~RUBY)
      "foo\\\\\\.bar".split("\\\\.")
    RUBY
  end

  it 'registers an offense when the method is split and corrects correctly complex special string chars' do
    expect_offense(<<~RUBY)
      "foo\\nbar\\nbaz\\n".split(/foo\\n\\.\\n/)
                              ^^^^^^^^^^^ Use string as argument instead of regexp.
    RUBY

    expect_correction(<<~RUBY)
      "foo\\nbar\\nbaz\\n".split("foo\\n.\\n")
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

  it 'registers and corrects an offense when `split` method argument is two or more speces regexp' do
    expect_offense(<<~RUBY)
      'foo         bar'.split(/  /)
                              ^^^^ Use string as argument instead of regexp.
    RUBY

    expect_correction(<<~RUBY)
      'foo         bar'.split("  ")
    RUBY
  end
end
