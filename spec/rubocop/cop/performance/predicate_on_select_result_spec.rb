# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Performance::PredicateOnSelectResult, :config do
  it 'registers an offense when using `#select` followed by `#any?`' do
    expect_offense(<<~RUBY)
      arr.select { |x| x > 1 }.any?
          ^^^^^^^^^^^^^^^^^^^^^^^^^ Use `any?` instead of `select.any?`.
    RUBY

    expect_correction(<<~RUBY)
      arr.any? { |x| x > 1 }
    RUBY
  end

  it 'registers an offense when using `#select` followed by `#empty?`' do
    expect_offense(<<~RUBY)
      arr.select { |x| x > 1 }.empty?
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use `none?` instead of `select.empty?`.
    RUBY

    expect_correction(<<~RUBY)
      arr.none? { |x| x > 1 }
    RUBY
  end

  it 'registers an offense when using `#select` followed by `#none?`' do
    expect_offense(<<~RUBY)
      arr.select { |x| x > 1 }.none?
          ^^^^^^^^^^^^^^^^^^^^^^^^^^ Use `none?` instead of `select.none?`.
    RUBY

    expect_correction(<<~RUBY)
      arr.none? { |x| x > 1 }
    RUBY
  end

  it 'registers an offense when using `#select` with block-pass followed by `#none?`' do
    expect_offense(<<~RUBY)
      arr.select(&:odd?).none?
          ^^^^^^^^^^^^^^^^^^^^ Use `none?` instead of `select.none?`.
    RUBY

    expect_correction(<<~RUBY)
      arr.none?(&:odd?)
    RUBY
  end

  it 'does not register an offense when using `#select` without a block followed by `#any?`' do
    expect_no_offenses(<<~RUBY)
      relation.select(:name).any?
      foo.select.any?
    RUBY
  end

  it 'does not register an offense when using `#select` followed by `#any?` with arguments' do
    expect_no_offenses(<<~RUBY)
      arr.select(&:odd?).any?(Integer)
      arr.select(&:odd?).any? { |x| x > 10 }
    RUBY
  end

  it 'does not register an offense when using `#any?`' do
    expect_no_offenses(<<~RUBY)
      arr.any? { |x| x > 1 }
    RUBY
  end
end
