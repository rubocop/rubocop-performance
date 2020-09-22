# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Performance::Sum do
  subject(:cop) { described_class.new }

  %i[inject reduce].each do |method|
    it "registers an offense and corrects when using `array.#{method}(10, :+)`" do
      expect_offense(<<~RUBY, method: method)
        array.#{method}(10, :+)
              ^{method}^^^^^^^^ Use `sum(10)` instead of `#{method}(10, :+)`.
      RUBY

      expect_correction(<<~RUBY)
        array.sum(10)
      RUBY
    end

    it "registers an offense and corrects when using `array.#{method}(10) { |acc, elem| acc + elem }`" do
      expect_offense(<<~RUBY, method: method)
        array.#{method}(10) { |acc, elem| acc + elem }
              ^{method}^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use `sum(10)` instead of `#{method}(10) { |acc, elem| acc + elem }`.
      RUBY

      expect_correction(<<~RUBY)
        array.sum(10)
      RUBY
    end

    it "registers an offense and corrects when using `array.#{method}(10) { |acc, elem| elem + acc }`" do
      expect_offense(<<~RUBY, method: method)
        array.#{method}(10) { |acc, elem| elem + acc }
              ^{method}^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use `sum(10)` instead of `#{method}(10) { |acc, elem| elem + acc }`.
      RUBY

      expect_correction(<<~RUBY)
        array.sum(10)
      RUBY
    end

    it "registers an offense and corrects when using `array.#{method}(0, :+)`" do
      expect_offense(<<~RUBY, method: method)
        array.#{method}(0, :+)
              ^{method}^^^^^^^ Use `sum` instead of `#{method}(0, :+)`.
      RUBY

      expect_correction(<<~RUBY)
        array.sum
      RUBY
    end

    it "registers an offense and corrects when using `array.#{method}(0.0, :+)`" do
      expect_offense(<<~RUBY, method: method)
        array.#{method}(0.0, :+)
              ^{method}^^^^^^^^^ Use `sum(0.0)` instead of `#{method}(0.0, :+)`.
      RUBY

      expect_correction(<<~RUBY)
        array.sum(0.0)
      RUBY
    end

    it "registers an offense and corrects when using `array.#{method}(init, :+)`" do
      expect_offense(<<~RUBY, method: method)
        array.#{method}(init, :+)
              ^{method}^^^^^^^^^^ Use `sum(init)` instead of `#{method}(init, :+)`.
      RUBY

      expect_correction(<<~RUBY)
        array.sum(init)
      RUBY
    end

    it 'does not autocorrect `:+` when initial value is not provided' do
      expect_offense(<<~RUBY, method: method)
        array.#{method}(:+)
              ^{method}^^^^ Use `sum` instead of `#{method}(:+)`.
      RUBY

      expect_no_corrections
    end

    it "registers an offense and corrects when using `array.#{method}(0, &:+)`" do
      expect_offense(<<~RUBY, method: method)
        array.#{method}(0, &:+)
              ^{method}^^^^^^^^ Use `sum` instead of `#{method}(0, &:+)`.
      RUBY

      expect_correction(<<~RUBY)
        array.sum
      RUBY
    end

    it 'does not autocorrect `&:+` when initial value is not provided' do
      expect_offense(<<~RUBY, method: method)
        array.#{method}(&:+)
              ^{method}^^^^^ Use `sum` instead of `#{method}(&:+)`.
      RUBY

      expect_no_corrections
    end

    it 'does not register an offense when block does not implement summation' do
      expect_no_offenses(<<~RUBY)
        array.#{method} { |acc, elem| elem * 2 }
      RUBY
    end

    it 'does not register an offense when using `sum`' do
      expect_no_offenses(<<~RUBY)
        array.sum
      RUBY
    end
  end

  %i[map collect].each do |method|
    it "registers an offense and corrects when using `array.#{method} { |elem| elem ** 2 }.sum`" do
      expect_offense(<<~RUBY, method: method)
        array.%{method} { |elem| elem ** 2 }.sum
              ^{method}^^^^^^^^^^^^^^^^^^^^^^^^^ Use `sum { ... }` instead of `%{method} { ... }.sum`.
      RUBY

      expect_correction(<<~RUBY)
        array.sum { |elem| elem ** 2 }
      RUBY
    end

    it "registers an offense and corrects when using `array.#{method}(&:count).sum`" do
      expect_offense(<<~RUBY, method: method)
        array.%{method}(&:count).sum
              ^{method}^^^^^^^^^^^^^ Use `sum { ... }` instead of `%{method} { ... }.sum`.
      RUBY

      expect_correction(<<~RUBY)
        array.sum(&:count)
      RUBY
    end

    it "registers an offense and corrects when using `array.#{method}(&:count).sum(10)`" do
      expect_offense(<<~RUBY, method: method)
        array.%{method}(&:count).sum(10)
              ^{method}^^^^^^^^^^^^^^^^^ Use `sum(10) { ... }` instead of `%{method} { ... }.sum(10)`.
      RUBY

      expect_correction(<<~RUBY)
        array.sum(10, &:count)
      RUBY
    end

    it "registers an offense and corrects when using `array.#{method} { elem ** 2 }.sum(10)`" do
      expect_offense(<<~RUBY, method: method)
        array.%{method} { |elem| elem ** 2 }.sum(10)
              ^{method}^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use `sum(10) { ... }` instead of `%{method} { ... }.sum(10)`.
      RUBY

      expect_correction(<<~RUBY)
        array.sum(10) { |elem| elem ** 2 }
      RUBY
    end

    it "does not register an offense when using `array.#{method}(&:count).sum { |elem| elem ** 2 }`" do
      expect_no_offenses(<<~RUBY)
        array.#{method}(&:count).sum { |elem| elem ** 2 }
      RUBY
    end

    it "does not register an offense when using `array.#{method}(&:count).sum(&:count)`" do
      expect_no_offenses(<<~RUBY)
        array.#{method}(&:count).sum(&:count)
      RUBY
    end
  end
end
