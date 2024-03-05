# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Performance::CollectionLiteralInMethod, :config do
  let(:cop_config) do
    { 'MinSize' => 1 }
  end

  context 'when inside `def` method definition' do
    it 'registers an offense when using Array literal' do
      expect_offense(<<~RUBY)
        def foo(e)
          [1, 2, 3].include?(e)
          ^^^^^^^^^ Avoid immutable Array literals in method definition. It is better to extract it into a constant.
        end
      RUBY
    end

    it 'registers an offense when using Hash literal' do
      expect_offense(<<~RUBY)
        def method
          { foo: :bar }.key?(:foo)
          ^^^^^^^^^^^^^ Avoid immutable Hash literals in method definition. It is better to extract it into a constant.
        end
      RUBY
    end
  end

  context 'when inside singleton method definition' do
    it 'registers an offense when using Array literal' do
      expect_offense(<<~RUBY)
        def bar.foo(e)
          [1, 2, 3].include?(e)
          ^^^^^^^^^ Avoid immutable Array literals in method definition. It is better to extract it into a constant.
        end
      RUBY
    end

    it 'registers an offense when using Hash literal' do
      expect_offense(<<~RUBY)
        def Bar.method
          { foo: :bar }.key?(:foo)
          ^^^^^^^^^^^^^ Avoid immutable Hash literals in method definition. It is better to extract it into a constant.
        end
      RUBY
    end
  end

  context 'when inside loop inside `def` method definition' do
    it 'registers an offense when using Array literal' do
      expect_offense(<<~RUBY)
        def foo(e)
          while i < 100
            [1, 2, 3].include?(e)
            ^^^^^^^^^ Avoid immutable Array literals in method definition. It is better to extract it into a constant.
          end
        end
      RUBY
    end

    it 'registers an offense when using Hash literal' do
      expect_offense(<<~RUBY)
        def method
          while i < 100
            { foo: :bar }.key?(:foo)
            ^^^^^^^^^^^^^ Avoid immutable Hash literals in method definition. It is better to extract it into a constant.
          end
        end
      RUBY
    end
  end

  context 'when not inside any type of method definition' do
    it 'does not register an offense when using Array literal' do
      expect_no_offenses(<<~RUBY)
        module Foo
          [1, 2, 3].include?(e)
        end
      RUBY
    end

    it 'does not register an offense when using Hash literal' do
      expect_no_offenses(<<~RUBY)
        class Foo
          { foo: :bar }.key?(:foo)
        end
      RUBY
    end
  end

  context 'when literal contains element of non basic type' do
    it 'does not register an offense when using Array literal' do
      expect_no_offenses(<<~RUBY)
        def method(e)
          [1, 2, variable].include?(e)
        end
      RUBY
    end

    it 'does not register an offense when using Hash literal' do
      expect_no_offenses(<<~RUBY)
        def method(e)
          { foo: { bar: variable } }.key?(:foo)
        end
      RUBY
    end
  end

  context 'when destructive method is called' do
    it 'does not register an offense when using Array literal' do
      expect_no_offenses(<<~RUBY)
        def method
          [1, nil, 3].compact!
        end
      RUBY
    end

    it 'does not register an offense when using Hash literal' do
      expect_no_offenses(<<~RUBY)
        def method
          { foo: :bar, baz: nil }.select! { |_k, v| !v.nil? }
        end
      RUBY
    end
  end

  context 'when none method is called' do
    it 'does not register an offense when using Array literal' do
      expect_no_offenses(<<~RUBY)
        def method
          array = [1, nil, 3]
        end
      RUBY
    end

    it 'does not register an offense when using Hash literal' do
      expect_no_offenses(<<~RUBY)
        def method()
          hash = { foo: :bar, baz: nil }
        end
      RUBY
    end
  end

  it 'does not register an offense when there are no literals in a def' do
    expect_no_offenses(<<~RUBY)
      def foo(x)
        puts x
      end
    RUBY
  end

  it 'does not register an offense when nondestructive method is called on nonliteral' do
    expect_no_offenses(<<~RUBY)
      def bar(array)
        array.all? { |x| x > 100 }
      end
    RUBY
  end

  context 'with MinSize of 2' do
    let(:cop_config) do
      { 'MinSize' => 2 }
    end

    it 'does not register an offense when using Array literal' do
      expect_no_offenses(<<~RUBY)
        def foo(e)
          [1].include?(e)
        end
      RUBY
    end

    it 'does not register an offense when using Hash literal' do
      expect_no_offenses(<<~RUBY)
        def foo(bar)
          { foo: :bar }.key?(bar)
        end
      RUBY
    end
  end
end
