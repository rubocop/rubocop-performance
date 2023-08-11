# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Performance::MapMethodChain, :config do
  it 'registers an offense when using `map` method chain and receiver is a method call' do
    expect_offense(<<~RUBY)
      array.map(&:foo).map(&:bar)
            ^^^^^^^^^^^^^^^^^^^^^ Use `map { |x| x.foo.bar }` instead of `map` method chain.
    RUBY
  end

  it 'registers an offense when using `collect` method chain and receiver is a method call' do
    expect_offense(<<~RUBY)
      array.collect(&:foo).collect(&:bar)
            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use `collect { |x| x.foo.bar }` instead of `collect` method chain.
    RUBY
  end

  it 'registers an offense when using `map` and `collect` method chain and receiver is a method call' do
    expect_offense(<<~RUBY)
      array.map(&:foo).collect(&:bar)
            ^^^^^^^^^^^^^^^^^^^^^^^^^ Use `map { |x| x.foo.bar }` instead of `map` method chain.
    RUBY
  end

  it 'registers an offense when using `map` method chain and receiver is a variable' do
    expect_offense(<<~RUBY)
      array = create_array
      array.map(&:foo).map(&:bar)
            ^^^^^^^^^^^^^^^^^^^^^ Use `map { |x| x.foo.bar }` instead of `map` method chain.
    RUBY
  end

  it 'registers an offense when using `map` method chain repeated three times' do
    expect_offense(<<~RUBY)
      array.map(&:foo).map(&:bar).map(&:baz)
            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use `map { |x| x.foo.bar.baz }` instead of `map` method chain.
    RUBY
  end

  it 'registers an offense when using `map` method chain repeated three times with safe navigation' do
    expect_offense(<<~RUBY)
      array&.map(&:foo).map(&:bar).map(&:baz)
             ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use `map { |x| x.foo.bar.baz }` instead of `map` method chain.
    RUBY
  end

  it 'does not register an offense when using `do_something` method chain and receiver is a method call' do
    expect_no_offenses(<<~RUBY)
      array.do_something(&:foo).do_something(&:bar)
    RUBY
  end

  it 'does not register an offense when there is a method call between `map` method chain' do
    expect_no_offenses(<<~RUBY)
      array.map(&:foo).do_something.map(&:bar)
    RUBY
  end

  it 'does not register an offense when using `flat_map` and `map` method chain and receiver is a method call' do
    expect_no_offenses(<<~RUBY)
      array.flat_map(&:foo).map(&:bar)
    RUBY
  end

  it 'does not register an offense when using `map(&:foo).join(', ')`' do
    expect_no_offenses(<<~RUBY)
      array = create_array
      array.map(&:foo).join(', ')
    RUBY
  end

  it 'does not register an offense when using `map(&:foo).join(', ')` with safe navigation' do
    expect_no_offenses(<<~RUBY)
      array = create_array
      array.map(&:foo).join(', ')
    RUBY
  end
end
