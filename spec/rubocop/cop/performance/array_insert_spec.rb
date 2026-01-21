# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Performance::ArrayInsert, :config do
  it 'registers an offense when using `insert(0, item)`' do
    expect_offense(<<~RUBY)
      array.insert(0, item)
            ^^^^^^^^^^^^^^^ Use `unshift` instead of `insert(0, ...)` for better performance.
    RUBY

    expect_correction(<<~RUBY)
      array.unshift(item)
    RUBY
  end

  it 'registers an offense when using `insert(0, multiple, items)`' do
    expect_offense(<<~RUBY)
      array.insert(0, 1, 2, 3)
            ^^^^^^^^^^^^^^^^^^ Use `unshift` instead of `insert(0, ...)` for better performance.
    RUBY

    expect_correction(<<~RUBY)
      array.unshift(1, 2, 3)
    RUBY
  end

  it 'registers an offense when using `insert(0, *items)` with splat' do
    expect_offense(<<~RUBY)
      array.insert(0, *items)
            ^^^^^^^^^^^^^^^^^ Use `unshift` instead of `insert(0, ...)` for better performance.
    RUBY

    expect_correction(<<~RUBY)
      array.unshift(*items)
    RUBY
  end

  it 'registers an offense with complex arguments' do
    expect_offense(<<~RUBY)
      array.insert(0, method_call, hash[:key], *rest)
            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use `unshift` instead of `insert(0, ...)` for better performance.
    RUBY

    expect_correction(<<~RUBY)
      array.unshift(method_call, hash[:key], *rest)
    RUBY
  end

  it 'does not register an offense when using insert with non-zero index' do
    expect_no_offenses(<<~RUBY)
      array.insert(1, item)
      array.insert(-1, item)
      array.insert(index, item)
    RUBY
  end

  it 'does not register an offense when using insert with variable index' do
    expect_no_offenses(<<~RUBY)
      position = 0
      array.insert(position, item)
    RUBY
  end

  it 'does not register an offense when using unshift' do
    expect_no_offenses(<<~RUBY)
      array.unshift(item)
      array.unshift(1, 2, 3)
      array.unshift(*items)
    RUBY
  end

  it 'handles insert in method chains correctly' do
    expect_offense(<<~RUBY)
      [1, 2, 3].insert(0, 0).reverse
                ^^^^^^^^^^^^ Use `unshift` instead of `insert(0, ...)` for better performance.
    RUBY

    expect_correction(<<~RUBY)
      [1, 2, 3].unshift(0).reverse
    RUBY
  end

  it 'handles parentheses-less method calls' do
    expect_offense(<<~RUBY)
      array.insert 0, item
            ^^^^^^^^^^^^^^ Use `unshift` instead of `insert(0, ...)` for better performance.
    RUBY

    expect_correction(<<~RUBY)
      array.unshift item
    RUBY
  end

  context 'when insert is called with only index 0 (edge case)' do
    it 'registers an offense and corrects properly' do
      expect_offense(<<~RUBY)
        array.insert(0)
              ^^^^^^^^^ Use `unshift` instead of `insert(0, ...)` for better performance.
      RUBY

      expect_correction(<<~RUBY)
        array.unshift
      RUBY
    end
  end

  context 'when insert is called with only index 0 and no parentheses (edge case)' do
    it 'registers an offense and corrects properly' do
      expect_offense(<<~RUBY)
        array.insert 0
              ^^^^^^^^ Use `unshift` instead of `insert(0, ...)` for better performance.
      RUBY

      expect_correction(<<~RUBY)
        array.unshift
      RUBY
    end
  end
end
