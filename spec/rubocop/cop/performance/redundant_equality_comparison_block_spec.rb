# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Performance::RedundantEqualityComparisonBlock, :config do
  context 'when TargetRubyVersion >= 2.5', :ruby25 do
    described_class::TARGET_METHODS.each do |method_name|
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
        expect_no_offenses(<<~RUBY)
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

    it 'does not register an offense when the block argument is destructured' do
      expect_no_offenses(<<~RUBY)
        items.any? { |(item)| item == other }
        items.any? { |(item, other_item)| item == other }
      RUBY
    end

    it 'does not register an offense when the block variable is used on both sides of `==`' do
      expect_no_offenses(<<~RUBY)
        items.all? { |item| item == item.do_something }
      RUBY
    end

    it 'does not register an offense when using not target methods with `===` comparison block' do
      expect_no_offenses(<<~RUBY)
        items.do_something { |item| item == other }
      RUBY
    end

    context 'when `AllowRegexpMatch: true`' do
      let(:cop_config) { { 'AllowRegexpMatch' => true } }

      it 'does not register an offense when using target method` with `=~` comparison block' do
        expect_no_offenses(<<~RUBY)
          items.all? { |item| item =~ pattern }
        RUBY
      end

      it 'does not register an offense when using target method with `match?` comparison block' do
        expect_no_offenses(<<~RUBY)
          items.all? { |item| item.match?(pattern) }
        RUBY
      end
    end

    context 'when `AllowRegexpMatch: false`' do
      let(:cop_config) { { 'AllowRegexpMatch' => false } }

      it 'registers an offense when using target method with `=~` comparison block' do
        expect_offense(<<~RUBY)
          items.all? { |item| item =~ pattern }
                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use `all?(pattern)` instead of block.
        RUBY
      end

      it 'registers an offense when using target method with `match?` comparison block' do
        expect_offense(<<~RUBY)
          items.all? { |item| item.match?(pattern) }
                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use `all?(pattern)` instead of block.
        RUBY
      end
    end
  end

  context 'when TargetRubyVersion <= 2.4', :ruby24, unsupported_on: :prism do
    # Ruby 2.4 does not support `items.all?(Klass)`.
    it 'does not register an offense when using `all?` with `is_a?` comparison block' do
      expect_no_offenses(<<~RUBY)
        items.all? { |item| item.is_a?(Klass) }
      RUBY
    end
  end

  it 'does not register an offense when using block argument is used for an argument of RHS operand' do
    expect_no_offenses(<<~RUBY)
      items.any? { |item| item == do_something(item) }
    RUBY
  end

  it 'does not register an offense when using block argument is used for a argument of LHS operand' do
    expect_no_offenses(<<~RUBY)
      items.any? { |item| do_something(item) == item }
    RUBY
  end

  it 'does not register an offense when using block argument is used for a nested argument of RHS operand' do
    expect_no_offenses(<<~RUBY)
      items.any? { |item| item == do_something[0..item] }
    RUBY
  end

  it 'does not register an offense when using block argument is used for a nested argument of LHS operand' do
    expect_no_offenses(<<~RUBY)
      items.any? { |item| do_something[0..item] == item }
    RUBY
  end

  it 'does not register an offense when the block is empty' do
    expect_no_offenses(<<~RUBY)
      items.any? { |item| }
    RUBY
  end

  it 'does not register an offense when the block takes no argument' do
    expect_no_offenses(<<~RUBY)
      items.any? { }
    RUBY
  end

  context 'when using numbered parameter', :ruby27 do
    it 'registers and corrects an offense when using `==` comparison block' do
      expect_offense(<<~RUBY)
        items.any? { _1 == other }
              ^^^^^^^^^^^^^^^^^^^^ Use `any?(other)` instead of block.
      RUBY

      expect_correction(<<~RUBY)
        items.any?(other)
      RUBY
    end

    it 'registers and corrects an offense when using `===` comparison block' do
      expect_offense(<<~RUBY)
        items.all? { pattern === _1 }
              ^^^^^^^^^^^^^^^^^^^^^^^ Use `all?(pattern)` instead of block.
      RUBY

      expect_correction(<<~RUBY)
        items.all?(pattern)
      RUBY
    end

    it 'does not register an offense when the block argument is used on both sides' do
      expect_no_offenses(<<~RUBY)
        items.any? { _1 == _1.foo }
      RUBY
    end
  end

  context 'when using `it` parameter', :ruby34, unsupported_on: :parser do
    it 'registers and corrects an offense when using `==` comparison block' do
      expect_offense(<<~RUBY)
        items.any? { it == other }
              ^^^^^^^^^^^^^^^^^^^^ Use `any?(other)` instead of block.
      RUBY

      expect_correction(<<~RUBY)
        items.any?(other)
      RUBY
    end

    it 'registers and corrects an offense when using `===` comparison block' do
      expect_offense(<<~RUBY)
        items.all? { pattern === it }
              ^^^^^^^^^^^^^^^^^^^^^^^ Use `all?(pattern)` instead of block.
      RUBY

      expect_correction(<<~RUBY)
        items.all?(pattern)
      RUBY
    end

    it 'does not register an offense when the block argument is used on both sides' do
      expect_no_offenses(<<~RUBY)
        items.any? { it == it.foo }
      RUBY
    end
  end

  context 'when the block argument is used in the other operand' do
    context 'with a named block parameter' do
      it 'does not register an offense for a method chain on the block argument' do
        expect_no_offenses(<<~RUBY)
          strings.all? { |x| x == x.strip.downcase }
        RUBY
      end

      it 'does not register an offense when both operands are the block argument' do
        expect_no_offenses(<<~RUBY)
          items.all? { |x| x == x }
        RUBY
      end

      it 'does not register an offense when the block argument is inside an array' do
        expect_no_offenses(<<~RUBY)
          items.all? { |x| x == [x] }
        RUBY
      end

      it 'does not register an offense when the block argument is inside parentheses' do
        expect_no_offenses(<<~RUBY)
          items.all? { |x| x == (x + 1) }
        RUBY
      end

      it 'does not register an offense for a longer chain on the left side' do
        expect_no_offenses(<<~RUBY)
          items.all? { |x| x.foo.bar == x }
        RUBY
      end
    end

    context 'with a numbered parameter', :ruby27 do
      it 'does not register an offense for a method chain on the block argument' do
        expect_no_offenses(<<~RUBY)
          strings.all? { _1 == _1.strip.downcase }
        RUBY
      end

      it 'does not register an offense when both operands are the block argument' do
        expect_no_offenses(<<~RUBY)
          items.all? { _1 == _1 }
        RUBY
      end

      it 'does not register an offense when the block argument is inside an array' do
        expect_no_offenses(<<~RUBY)
          items.all? { _1 == [_1] }
        RUBY
      end

      it 'does not register an offense when the block argument is inside parentheses' do
        expect_no_offenses(<<~RUBY)
          items.all? { _1 == (_1 + 1) }
        RUBY
      end

      it 'does not register an offense for a longer chain on the left side' do
        expect_no_offenses(<<~RUBY)
          items.all? { _1.foo.bar == _1 }
        RUBY
      end
    end

    context 'with the `it` parameter', :ruby34, unsupported_on: :parser do
      it 'does not register an offense for a method chain on the block argument' do
        expect_no_offenses(<<~RUBY)
          strings.all? { it == it.strip.downcase }
        RUBY
      end

      it 'does not register an offense when both operands are the block argument' do
        expect_no_offenses(<<~RUBY)
          items.all? { it == it }
        RUBY
      end

      it 'does not register an offense when the block argument is inside an array' do
        expect_no_offenses(<<~RUBY)
          items.all? { it == [it] }
        RUBY
      end

      it 'does not register an offense when the block argument is inside parentheses' do
        expect_no_offenses(<<~RUBY)
          items.all? { it == (it + 1) }
        RUBY
      end

      it 'does not register an offense for a longer chain on the left side' do
        expect_no_offenses(<<~RUBY)
          items.all? { it.foo.bar == it }
        RUBY
      end
    end
  end

  context 'when the comparison has no receiver or no argument' do
    context 'with a named block parameter' do
      it 'does not register an offense for `is_a?` without a receiver' do
        expect_no_offenses(<<~RUBY)
          items.all? { |x| is_a?(x.class) }
        RUBY
      end

      it 'does not register an offense for `is_a?` without an argument' do
        expect_no_offenses(<<~RUBY)
          items.all? { |x| x.is_a? }
        RUBY
      end
    end

    context 'with a numbered parameter', :ruby27 do
      it 'does not register an offense for `is_a?` without a receiver' do
        expect_no_offenses(<<~RUBY)
          items.all? { is_a?(_1.class) }
        RUBY
      end

      it 'does not register an offense for `is_a?` without an argument' do
        expect_no_offenses(<<~RUBY)
          items.all? { _1.is_a? }
        RUBY
      end
    end

    context 'with the `it` parameter', :ruby34, unsupported_on: :parser do
      it 'does not register an offense for `is_a?` without a receiver' do
        expect_no_offenses(<<~RUBY)
          items.all? { is_a?(it.class) }
        RUBY
      end

      it 'does not register an offense for `is_a?` without an argument' do
        expect_no_offenses(<<~RUBY)
          items.all? { it.is_a? }
        RUBY
      end
    end
  end
end
