# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Performance::Defined, :config do
  it 'registers an offense when using `#class_variable_defined?`' do
    expect_offense(<<~RUBY)
      return if class_variable_defined?(:@@foo)
                ^^^^^^^^^^^^^^^^^^^^^^^ Use `defined?` instead of `class_variable_defined?`.
    RUBY

    expect_correction(<<~RUBY)
      return if defined?(@@foo)
    RUBY
  end

  it 'registers an offense when using `#const_defined?`' do
    expect_offense(<<~RUBY)
      return if const_defined?(:FOO)
                ^^^^^^^^^^^^^^ Use `defined?` instead of `const_defined?`.
    RUBY

    expect_correction(<<~RUBY)
      return if defined?(FOO)
    RUBY
  end

  it 'registers an offense when using `#instance_variable_defined?`' do
    expect_offense(<<~RUBY)
      return if instance_variable_defined?(:@foo)
                ^^^^^^^^^^^^^^^^^^^^^^^^^^ Use `defined?` instead of `instance_variable_defined?`.
    RUBY

    expect_correction(<<~RUBY)
      return if defined?(@foo)
    RUBY
  end

  it 'does not register an offense when using `#defined?`' do
    expect_no_offenses(<<~RUBY)
      defined?(@foo)
    RUBY
  end

  it 'does not register an offense when using `#_defined?` on explicit receiver' do
    expect_no_offenses(<<~RUBY)
      x.instance_variable_defined?(:@foo)
    RUBY
  end

  it 'does not register an offense when using `#_defined?` with non basic literal expression' do
    expect_no_offenses(<<~RUBY)
      instance_variable_defined?(foo_ivar)
    RUBY
  end

  it 'does not register an offense when using `#const_defined?` with non `true` `inherit` option' do
    expect_no_offenses(<<~RUBY)
      const_defined?(:FOO, false)
    RUBY
  end

  it 'registers an offense when using `#const_defined?` with `true` `inherit` option' do
    expect_offense(<<~RUBY)
      return if const_defined?(:FOO, true)
                ^^^^^^^^^^^^^^ Use `defined?` instead of `const_defined?`.
    RUBY

    expect_correction(<<~RUBY)
      return if defined?(FOO)
    RUBY
  end

  it 'registers an offense when using `#_defined?` as a non condition' do
    expect_offense(<<~RUBY)
      const_defined?(:FOO)
      ^^^^^^^^^^^^^^ Use `defined?` instead of `const_defined?`.
    RUBY

    expect_correction(<<~RUBY)
      !defined?(FOO).nil?
    RUBY
  end
end
