# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Performance::BigDecimalWithNumericArgument, :config do
  context 'when Ruby >= 3.1', :ruby31 do
    it 'registers an offense and corrects when using `BigDecimal` with string' do
      expect_offense(<<~RUBY)
        BigDecimal('1')
                   ^^^ Convert string literal to numeric and pass it to `BigDecimal`.
      RUBY

      expect_correction(<<~RUBY)
        BigDecimal(1)
      RUBY
    end

    it 'registers an offense and corrects when using `String#to_d`' do
      expect_offense(<<~RUBY)
        '1'.to_d
        ^^^ Convert string literal to numeric and pass it to `BigDecimal`.
      RUBY

      expect_correction(<<~RUBY)
        BigDecimal(1)
      RUBY
    end

    it 'registers an offense and corrects when using `BigDecimal` with float string' do
      expect_offense(<<~RUBY)
        BigDecimal('1.5', exception: true)
                   ^^^^^ Convert string literal to numeric and pass it to `BigDecimal`.
      RUBY

      expect_correction(<<~RUBY)
        BigDecimal(1.5, exception: true)
      RUBY
    end

    it 'registers an offense and corrects when using float `String#to_d`' do
      expect_offense(<<~RUBY)
        '1.5'.to_d(exception: true)
        ^^^^^ Convert string literal to numeric and pass it to `BigDecimal`.
      RUBY

      expect_correction(<<~RUBY)
        BigDecimal(1.5, exception: true)
      RUBY
    end

    it 'registers an offense when using `BigDecimal` with float string and precision' do
      expect_offense(<<~RUBY)
        BigDecimal('3.14', 1)
                   ^^^^^^ Convert string literal to numeric and pass it to `BigDecimal`.
      RUBY

      expect_correction(<<~RUBY)
        BigDecimal(3.14, 1)
      RUBY
    end

    it 'registers an offense when using float `String#to_d` with precision' do
      expect_offense(<<~RUBY)
        '3.14'.to_d(1)
        ^^^^^^ Convert string literal to numeric and pass it to `BigDecimal`.
      RUBY

      expect_correction(<<~RUBY)
        BigDecimal(3.14, 1)
      RUBY
    end

    it 'registers an offense when using `BigDecimal` with float string and non-literal precision' do
      expect_offense(<<~RUBY)
        precision = 1
        BigDecimal('3.14', precision)
                   ^^^^^^ Convert string literal to numeric and pass it to `BigDecimal`.
      RUBY

      expect_correction(<<~RUBY)
        precision = 1
        BigDecimal(3.14, precision)
      RUBY
    end

    it 'registers an offense when using float `String#to_d` with non-literal precision' do
      expect_offense(<<~RUBY)
        precision = 1
        '3.14'.to_d(precision)
        ^^^^^^ Convert string literal to numeric and pass it to `BigDecimal`.
      RUBY

      expect_correction(<<~RUBY)
        precision = 1
        BigDecimal(3.14, precision)
      RUBY
    end

    it 'registers an offense when using `BigDecimal` with float string, precision, and a keyword argument' do
      expect_offense(<<~RUBY)
        BigDecimal('3.14', 1, exception: true)
                   ^^^^^^ Convert string literal to numeric and pass it to `BigDecimal`.
      RUBY

      expect_correction(<<~RUBY)
        BigDecimal(3.14, 1, exception: true)
      RUBY
    end

    it 'registers an offense when using float `String#to_d` with precision and a keyword argument' do
      expect_offense(<<~RUBY)
        '3.14'.to_d(1, exception: true)
        ^^^^^^ Convert string literal to numeric and pass it to `BigDecimal`.
      RUBY

      expect_correction(<<~RUBY)
        BigDecimal(3.14, 1, exception: true)
      RUBY
    end

    it 'does not register an offense when using `BigDecimal` with integer' do
      expect_no_offenses(<<~RUBY)
        BigDecimal(1)
      RUBY
    end

    it 'does not register an offense when using `Integer#to_d`' do
      expect_no_offenses(<<~RUBY)
        1.to_d
      RUBY
    end
  end

  context 'when Ruby <= 3.0', :ruby30, unsupported_on: :prism do
    it 'does not register an offense and corrects when using `BigDecimal` with string' do
      expect_no_offenses(<<~RUBY)
        BigDecimal('1')
      RUBY
    end
  end
end
