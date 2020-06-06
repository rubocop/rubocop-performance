# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Performance::BigDecimalWithNumericArgument do
  subject(:cop) { described_class.new }

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
      BigDecimal(1.5, 2, exception: true)
                 ^^^ Convert numeric argument to string before passing to `BigDecimal`.
    RUBY

    expect_correction(<<~RUBY)
      BigDecimal('1.5', 2, exception: true)
    RUBY
  end

  it 'does not register an offense when using `BigDecimal` with string' do
    expect_no_offenses(<<~RUBY)
      BigDecimal('1')
    RUBY
  end
end
