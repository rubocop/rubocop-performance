# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Performance::BigDecimalWithNumericArgument, :config do
  it 'registers an offense and corrects when using `BigDecimal` with integer' do
    expect_offense(<<~RUBY)
      BigDecimal(1)
                 ^ Convert numeric literal to string and pass it to `BigDecimal`.
    RUBY

    expect_correction(<<~RUBY)
      BigDecimal('1')
    RUBY
  end

  it 'registers an offense and corrects when using `Integer#to_d`' do
    expect_offense(<<~RUBY)
      1.to_d
      ^ Convert numeric literal to string and pass it to `BigDecimal`.
    RUBY

    expect_correction(<<~RUBY)
      BigDecimal('1')
    RUBY
  end

  it 'registers an offense and corrects when using `BigDecimal` with float' do
    expect_offense(<<~RUBY)
      BigDecimal(1.5, exception: true)
                 ^^^ Convert numeric literal to string and pass it to `BigDecimal`.
    RUBY

    expect_correction(<<~RUBY)
      BigDecimal('1.5', exception: true)
    RUBY
  end

  it 'registers an offense and corrects when using `Float#to_d`' do
    expect_offense(<<~RUBY)
      1.5.to_d(exception: true)
      ^^^ Convert numeric literal to string and pass it to `BigDecimal`.
    RUBY

    expect_correction(<<~RUBY)
      BigDecimal('1.5', exception: true)
    RUBY
  end

  it 'registers an offense when using `BigDecimal` with float and precision' do
    expect_offense(<<~RUBY)
      BigDecimal(3.14, 1)
                 ^^^^ Convert numeric literal to string and pass it to `BigDecimal`.
    RUBY

    expect_correction(<<~RUBY)
      BigDecimal('3.14', 1)
    RUBY
  end

  it 'registers an offense when using `Float#to_d` with precision' do
    expect_offense(<<~RUBY)
      3.14.to_d(1)
      ^^^^ Convert numeric literal to string and pass it to `BigDecimal`.
    RUBY

    expect_correction(<<~RUBY)
      BigDecimal('3.14', 1)
    RUBY
  end

  it 'registers an offense when using `BigDecimal` with float and non-literal precision' do
    expect_offense(<<~RUBY)
      precision = 1
      BigDecimal(3.14, precision)
                 ^^^^ Convert numeric literal to string and pass it to `BigDecimal`.
    RUBY

    expect_correction(<<~RUBY)
      precision = 1
      BigDecimal('3.14', precision)
    RUBY
  end

  it 'registers an offense when using `Float#to_d` with non-literal precision' do
    expect_offense(<<~RUBY)
      precision = 1
      3.14.to_d(precision)
      ^^^^ Convert numeric literal to string and pass it to `BigDecimal`.
    RUBY

    expect_correction(<<~RUBY)
      precision = 1
      BigDecimal('3.14', precision)
    RUBY
  end

  it 'registers an offense when using `BigDecimal` with float, precision, and a keyword argument' do
    expect_offense(<<~RUBY)
      BigDecimal(3.14, 1, exception: true)
                 ^^^^ Convert numeric literal to string and pass it to `BigDecimal`.
    RUBY

    expect_correction(<<~RUBY)
      BigDecimal('3.14', 1, exception: true)
    RUBY
  end

  it 'registers an offense when using `Float#to_d` with precision and a keyword argument' do
    expect_offense(<<~RUBY)
      3.14.to_d(1, exception: true)
      ^^^^ Convert numeric literal to string and pass it to `BigDecimal`.
    RUBY

    expect_correction(<<~RUBY)
      BigDecimal('3.14', 1, exception: true)
    RUBY
  end

  it 'does not register an offense when using `BigDecimal` with string' do
    expect_no_offenses(<<~RUBY)
      BigDecimal('1')
    RUBY
  end

  it 'does not register an offense when using `String#to_d`' do
    expect_no_offenses(<<~RUBY)
      '1'.to_d
    RUBY
  end
end
