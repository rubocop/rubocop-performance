# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Performance::SortReverse, :config do
  let(:config) do
    # Suppress ChainArrayAllocation offenses
    RuboCop::Config.new('Performance/ChainArrayAllocation' => { 'Enabled' => false })
  end

  it 'registers an offense and corrects when sorting in reverse order' do
    expect_offense(<<~RUBY)
      array.sort { |a, b| b <=> a }
            ^^^^^^^^^^^^^^^^^^^^^^^ Use `sort.reverse` instead.
    RUBY

    expect_correction(<<~RUBY)
      array.sort.reverse
    RUBY
  end

  it 'registers an offense and corrects when sorting in reverse order with safe navigation' do
    expect_offense(<<~RUBY)
      array&.sort { |a, b| b <=> a }
             ^^^^^^^^^^^^^^^^^^^^^^^ Use `sort&.reverse` instead.
    RUBY

    expect_correction(<<~RUBY)
      array&.sort&.reverse
    RUBY
  end

  context 'when using numbered parameter', :ruby27 do
    it 'registers an offense and corrects when sorting in reverse order' do
      expect_offense(<<~RUBY)
        array.sort { _2 <=> _1 }
              ^^^^^^^^^^^^^^^^^^ Use `sort.reverse` instead.
      RUBY

      expect_correction(<<~RUBY)
        array.sort.reverse
      RUBY
    end

    it 'does not register an offense when sorting in direct order' do
      expect_no_offenses(<<~RUBY)
        array.sort { _1 <=> _2 }
      RUBY
    end

    it 'does not register an offense when sorting in reverse order by some property' do
      expect_no_offenses(<<~RUBY)
        array.sort { _2.x <=> _1.x }
      RUBY
    end
  end

  it 'does not register an offense when sorting in direct order' do
    expect_no_offenses(<<~RUBY)
      array.sort { |a, b| a <=> b }
    RUBY
  end

  it 'does not register an offense when sorting in reverse order by some property' do
    expect_no_offenses(<<~RUBY)
      array.sort { |a, b| b.x <=> a.x }
    RUBY
  end

  it 'does not register an offense when using `sort.reverse`' do
    expect_no_offenses(<<~RUBY)
      array.sort.reverse
    RUBY
  end
end
