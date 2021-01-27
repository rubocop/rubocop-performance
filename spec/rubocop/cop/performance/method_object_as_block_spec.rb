# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Performance::MethodObjectAsBlock, :config do
  it 'registers an offense when using `&method` without a receiver as an argument' do
    expect_offense(<<~RUBY)
      array.map(&method(:do_something))
                ^^^^^^^^^^^^^^^^^^^^^^ Use block explicitly instead of block-passing a method object.
    RUBY
  end

  it 'registers an offense when using `&method` with a receiver as an argument' do
    expect_offense(<<~RUBY)
      array.map(&foo.method(:do_something))
                ^^^^^^^^^^^^^^^^^^^^^^^^^^ Use block explicitly instead of block-passing a method object.
    RUBY
  end

  it 'registers an offense when using `&method` among the other arguments' do
    expect_offense(<<~RUBY)
      array.detect(-> { 10 }, &method(:do_something))
                              ^^^^^^^^^^^^^^^^^^^^^^ Use block explicitly instead of block-passing a method object.
    RUBY
  end

  it 'does not register an offense when using `method(...)` without a block pass as argument' do
    expect_no_offenses(<<~RUBY)
      array.map(method(:do_something))
    RUBY
  end

  it 'does not register an offense when calling a method with an explicit block' do
    expect_no_offenses(<<~RUBY)
      array.map { |e| do_something(e) }
    RUBY
  end
end
