# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Performance::RedundantBlockCall, :config do
  it 'registers and autocorrects an offense when `block.call` without arguments' do
    expect_offense(<<~RUBY)
      def method(&block)
        block.call
        ^^^^^^^^^^ Use `yield` instead of `block.call`.
      end
    RUBY

    expect_correction(<<~RUBY)
      def method(&block)
        yield
      end
    RUBY
  end

  it 'registers and autocorrects an offense when `block.call` with empty parentheses' do
    expect_offense(<<~RUBY)
      def method(&block)
        block.call()
        ^^^^^^^^^^^^ Use `yield` instead of `block.call`.
      end
    RUBY

    expect_correction(<<~RUBY)
      def method(&block)
        yield
      end
    RUBY
  end

  it 'registers and corrects an offense when using `block.call` in a class method' do
    expect_offense(<<~RUBY)
      def self.method(&block)
        block.call
        ^^^^^^^^^^ Use `yield` instead of `block.call`.
      end
    RUBY

    expect_correction(<<~RUBY)
      def self.method(&block)
        yield
      end
    RUBY
  end

  it 'registers and autocorrects an offense when `block.call` with arguments' do
    expect_offense(<<~RUBY)
      def method(&block)
        block.call 1, 2
        ^^^^^^^^^^^^^^^ Use `yield` instead of `block.call`.
      end
    RUBY

    expect_correction(<<~RUBY)
      def method(&block)
        yield 1, 2
      end
    RUBY
  end

  it 'registers and autocorrects an offense when  multiple occurrences of `block.call` with arguments' do
    expect_offense(<<~RUBY)
      def method(&block)
        block.call 1
        ^^^^^^^^^^^^ Use `yield` instead of `block.call`.
        block.call 2
        ^^^^^^^^^^^^ Use `yield` instead of `block.call`.
      end
    RUBY

    expect_correction(<<~RUBY)
      def method(&block)
        yield 1
        yield 2
      end
    RUBY
  end

  it 'registers and autocorrects when even when block arg has a different name' do
    expect_offense(<<~RUBY)
      def method(&func)
        func.call
        ^^^^^^^^^ Use `yield` instead of `func.call`.
      end
    RUBY

    expect_correction(<<~RUBY)
      def method(&func)
        yield
      end
    RUBY
  end

  it 'accepts a block that is not `call`ed' do
    expect_no_offenses(<<~RUBY)
      def method(&block)
       something.call
      end
    RUBY
  end

  it 'accepts an empty method body' do
    expect_no_offenses(<<~RUBY)
      def method(&block)
      end
    RUBY
  end

  it 'accepts another block being passed as the only arg' do
    expect_no_offenses(<<~RUBY)
      def method(&block)
        block.call(&some_proc)
      end
    RUBY
  end

  it 'accepts another block being passed along with other args' do
    expect_no_offenses(<<~RUBY)
      def method(&block)
        block.call(1, &some_proc)
      end
    RUBY
  end

  it 'accepts another block arg in at least one occurrence of block.call' do
    expect_no_offenses(<<~RUBY)
      def method(&block)
        block.call(1, &some_proc)
        block.call(2)
      end
    RUBY
  end

  it 'accepts an optional block that is defaulted' do
    expect_no_offenses(<<~RUBY)
      def method(&block)
        block ||= ->(i) { puts i }
        block.call(1)
      end
    RUBY
  end

  it 'accepts an optional block that is overridden by local variable' do
    expect_no_offenses(<<~RUBY)
      def method(&block)
        block = ->(i) { puts i }
        block.call(1)
      end
    RUBY
  end

  it 'accepts an optional block that is overridden by block variable' do
    expect_no_offenses(<<~RUBY)
      def method(&block)
        ->(i) { puts i }.then do |block|
          block.call(1)
        end
      end
    RUBY
  end

  it 'registers and corrects an offense when an optional block that is not overridden by block variable' do
    expect_offense(<<~RUBY)
      def method(&block)
        ->(i) { puts i }.then do |_block|
          block.call(1)
          ^^^^^^^^^^^^^ Use `yield` instead of `block.call`.
        end
      end
    RUBY

    expect_correction(<<~RUBY)
      def method(&block)
        ->(i) { puts i }.then do |_block|
          yield(1)
        end
      end
    RUBY
  end

  it 'formats the error message for func.call(1) correctly' do
    expect_offense(<<~RUBY)
      def method(&func)
        func.call(1)
        ^^^^^^^^^^^^ Use `yield` instead of `func.call`.
      end
    RUBY
  end

  it 'registers and autocorrects an offense using parentheses when block.call uses parentheses' do
    expect_offense(<<~RUBY)
      def method(&block)
        block.call(a, b)
        ^^^^^^^^^^^^^^^^ Use `yield` instead of `block.call`.
      end
    RUBY

    expect_correction(<<~RUBY)
      def method(&block)
        yield(a, b)
      end
    RUBY
  end

  it 'registers and autocorrects an offense when the result of the call is used in a scope that requires parentheses' do
    expect_offense(<<~RUBY)
      def method(&block)
        each_with_object({}) do |(key, value), acc|
          acc.merge!(block.call(key) => rhs[value])
                     ^^^^^^^^^^^^^^^ Use `yield` instead of `block.call`.
        end
      end
    RUBY

    expect_correction(<<~RUBY)
      def method(&block)
        each_with_object({}) do |(key, value), acc|
          acc.merge!(yield(key) => rhs[value])
        end
      end
    RUBY
  end
end
