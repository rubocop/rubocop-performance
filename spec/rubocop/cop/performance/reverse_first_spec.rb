# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Performance::ReverseFirst, :config do
  it 'registers an offense and corrects when using `#reverse.first(5)`' do
    expect_offense(<<~RUBY)
      array.reverse.first(5)
            ^^^^^^^^^^^^^^^^ Use `last(5).reverse` instead of `reverse.first(5)`.
    RUBY

    expect_correction(<<~RUBY)
      array.last(5).reverse
    RUBY
  end

  it 'registers an offense and corrects when using `#reverse.first`' do
    expect_offense(<<~RUBY)
      array.reverse.first
            ^^^^^^^^^^^^^ Use `last` instead of `reverse.first`.
    RUBY

    expect_correction(<<~RUBY)
      array.last
    RUBY
  end

  it 'registers an offense and corrects when using `#reverse.first` with safe navigation operator' do
    expect_offense(<<~RUBY)
      array&.reverse.first
             ^^^^^^^^^^^^^ Use `last` instead of `reverse.first`.
    RUBY

    expect_correction(<<~RUBY)
      array&.last
    RUBY
  end

  it 'does not register an offense when `#reverse` is not followed by `#first`' do
    expect_no_offenses(<<~RUBY)
      array.reverse
    RUBY

    expect_no_offenses(<<~RUBY)
      array.reverse.last(5)
    RUBY
  end
end
