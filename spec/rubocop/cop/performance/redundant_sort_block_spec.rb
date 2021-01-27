# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Performance::RedundantSortBlock, :config do
  it 'registers an offense and corrects when sorting in direct order' do
    expect_offense(<<~RUBY)
      array.sort { |a, b| a <=> b }
            ^^^^^^^^^^^^^^^^^^^^^^^ Use `sort` instead of `sort { |a, b| a <=> b }`.
    RUBY

    expect_correction(<<~RUBY)
      array.sort
    RUBY
  end

  it 'does not register an offense when sorting in reverse order' do
    expect_no_offenses(<<~RUBY)
      array.sort { |a, b| b <=> a }
    RUBY
  end

  it 'does not register an offense when sorting in direct order by some property' do
    expect_no_offenses(<<~RUBY)
      array.sort { |a, b| a.x <=> b.x }
    RUBY
  end

  it 'does not register an offense when using `sort`' do
    expect_no_offenses(<<~RUBY)
      array.sort
    RUBY
  end
end
