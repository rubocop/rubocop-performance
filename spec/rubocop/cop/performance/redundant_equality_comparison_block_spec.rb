# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Performance::RedundantEqualityComparisonBlock, :config do
  context 'TargetRubyVersion >= 2.5', :ruby25 do
    RuboCop::Cop::Performance::RedundantEqualityComparisonBlock::TARGET_METHODS.each do |method_name|
      it "registers and corrects an offense when using `#{method_name}` with `===` comparison block" do
        expect_offense(<<~RUBY, method_name: method_name)
          items.#{method_name} { |item| pattern === item }
                ^{method_name}^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use `#{method_name}(pattern)` instead of block.
        RUBY

        expect_correction(<<~RUBY)
          items.#{method_name}(pattern)
        RUBY
      end

      it "registers and corrects an offense when using `#{method_name}` with `==` comparison block" do
        expect_offense(<<~RUBY, method_name: method_name)
          items.#{method_name} { |item| item == other }
                ^{method_name}^^^^^^^^^^^^^^^^^^^^^^^^^ Use `#{method_name}(other)` instead of block.
        RUBY

        expect_correction(<<~RUBY)
          items.#{method_name}(other)
        RUBY
      end

      it "registers and corrects an offense when using `#{method_name}` with `is_a?` comparison block" do
        expect_offense(<<~RUBY, method_name: method_name)
          items.#{method_name} { |item| item.is_a?(Klass) }
                ^{method_name}^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use `#{method_name}(Klass)` instead of block.
        RUBY

        expect_correction(<<~RUBY)
          items.#{method_name}(Klass)
        RUBY
      end

      it "registers and corrects an offense when using `#{method_name}` with `kind_of?` comparison block" do
        expect_offense(<<~RUBY, method_name: method_name)
          items.#{method_name} { |item| item.kind_of?(Klass) }
                ^{method_name}^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use `#{method_name}(Klass)` instead of block.
        RUBY

        expect_correction(<<~RUBY)
          items.#{method_name}(Klass)
        RUBY
      end

      it "does not register an offense when using `#{method_name}` with `===` comparison block and" \
         'block argument is not used as a receiver for `===`' do
        expect_no_offenses(<<~RUBY, method_name: method_name)
          items.#{method_name} { |item| item === pattern }
        RUBY
      end
    end

    it 'registers and corrects an offense when using method chanin and `all?` with `===` comparison block' do
      expect_offense(<<~RUBY)
        items.do_something.all? { |item| item == other }
                           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use `all?(other)` instead of block.
      RUBY

      expect_correction(<<~RUBY)
        items.do_something.all?(other)
      RUBY
    end

    it 'does not register an offense when using `all?` without `===` comparison block' do
      expect_no_offenses(<<~RUBY)
        items.all?(other)
      RUBY
    end

    it 'does not register an offense when using multiple block arguments' do
      expect_no_offenses(<<~RUBY)
        items.all? { |key, _value| key == other }
      RUBY
    end

    it 'does not register an offense when using block argument is used for an argument of `is_a`' do
      expect_no_offenses(<<~RUBY)
        klasses.all? { |klass| item.is_a?(klass) }
      RUBY
    end

    it 'does not register an offense when using block argument is used for an argument of `kind_of?`' do
      expect_no_offenses(<<~RUBY)
        klasses.all? { |klass| item.kind_of?(klass) }
      RUBY
    end

    it 'does not register an offense when using block argument is not used as it is' do
      expect_no_offenses(<<~RUBY)
        items.all? { |item| item.do_something == other }
      RUBY
    end

    it 'does not register an offense when using one argument with comma separator in block argument' do
      expect_no_offenses(<<~RUBY)
        items.all? { |item,| item == other }
      RUBY
    end

    it 'does not register an offense when using not target methods with `===` comparison block' do
      expect_no_offenses(<<~RUBY)
        items.do_something { |item| item == other }
      RUBY
    end
  end

  context 'TargetRubyVersion <= 2.4', :ruby24 do
    # Ruby 2.4 does not support `items.all?(Klass)`.
    it 'does not register an offense when using `all?` with `is_a?` comparison block' do
      expect_no_offenses(<<~RUBY)
        items.all? { |item| item.is_a?(Klass) }
      RUBY
    end
  end
end
