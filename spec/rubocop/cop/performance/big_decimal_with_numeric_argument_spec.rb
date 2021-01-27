# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Performance::BigDecimalWithNumericArgument, :config do
  it 'registers an offense and corrects when using `BigDecimal` with integer' do
    expect_offense(<<~RUBY)
      BigDecimal(1)
                 ^ Convert numeric argument to string before passing to `BigDecimal`.
    RUBY

    expect_correction(<<~RUBY)
      BigDecimal('1')
    RUBY
  end

  it 'registers an offense and corrects when using `BigDecimal` with float' do
    expect_offense(<<~RUBY)
      BigDecimal(1.5, exception: true)
                 ^^^ Convert numeric argument to string before passing to `BigDecimal`.
    RUBY

    expect_correction(<<~RUBY)
      BigDecimal('1.5', exception: true)
    RUBY
  end

  it 'does not register an offense when using `BigDecimal` with float and precision' do
    expect_no_offenses(<<~RUBY)
      BigDecimal(3.14, 1)
    RUBY
  end

  it 'does not register an offense when using `BigDecimal` with float and non-literal precision' do
    expect_no_offenses(<<~RUBY)
      precision = 1
      BigDecimal(3.14, precision)
    RUBY
  end

  it 'does not register an offense when using `BigDecimal` with float, precision, and a keyword argument' do
    expect_no_offenses(<<~RUBY)
      BigDecimal(3.14, 1, exception: true)
    RUBY
  end

  it 'does not register an offense when using `BigDecimal` with string' do
    expect_no_offenses(<<~RUBY)
      BigDecimal('1')
    RUBY
  end
end
