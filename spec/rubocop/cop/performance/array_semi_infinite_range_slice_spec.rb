# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Performance::ArraySemiInfiniteRangeSlice, :config do
  context 'when TargetRubyVersion >= 2.7', :ruby27 do
    it 'registers an offense and corrects when using `[]` with beginless range' do
      expect_offense(<<~RUBY)
        array[..2]
        ^^^^^^^^^^ Use `take` instead of `[]` with semi-infinite range.
        array[...2]
        ^^^^^^^^^^^ Use `take` instead of `[]` with semi-infinite range.
      RUBY

      expect_correction(<<~RUBY)
        array.take(3)
        array.take(2)
      RUBY
    end

    it 'registers an offense and corrects when using `[]` with endless range' do
      expect_offense(<<~RUBY)
        array[2..]
        ^^^^^^^^^^ Use `drop` instead of `[]` with semi-infinite range.
        array[2...]
        ^^^^^^^^^^^ Use `drop` instead of `[]` with semi-infinite range.
      RUBY

      expect_correction(<<~RUBY)
        array.drop(2)
        array.drop(2)
      RUBY
    end

    it 'registers an offense and corrects when using `slice` with semi-infinite ranges' do
      expect_offense(<<~RUBY)
        array.slice(2..)
        ^^^^^^^^^^^^^^^^ Use `drop` instead of `slice` with semi-infinite range.
        array.slice(..2)
        ^^^^^^^^^^^^^^^^ Use `take` instead of `slice` with semi-infinite range.
      RUBY

      expect_correction(<<~RUBY)
        array.drop(2)
        array.take(3)
      RUBY
    end

    it 'registers an offense and corrects when using `slice` with semi-infinite ranges and safe navigation operator' do
      expect_offense(<<~RUBY)
        array&.slice(2..)
        ^^^^^^^^^^^^^^^^^ Use `drop` instead of `slice` with semi-infinite range.
        array&.slice(..2)
        ^^^^^^^^^^^^^^^^^ Use `take` instead of `slice` with semi-infinite range.
      RUBY

      expect_correction(<<~RUBY)
        array.drop(2)
        array.take(3)
      RUBY
    end

    it 'does not register an offense when using `[]` with full range' do
      expect_no_offenses(<<~RUBY)
        array[0..2]
      RUBY
    end

    it 'does not register an offense when using `[]` with semi-infinite range with non literal' do
      expect_no_offenses(<<~RUBY)
        array[..index]
        array[index..]
      RUBY
    end

    it 'does not register an offense when using `[]` with semi-infinite range with negative int' do
      expect_no_offenses(<<~RUBY)
        array[..-2]
        array[-2..]
      RUBY
    end

    it 'does not registers an offense when using `[]` with endless range for string literal' do
      expect_no_offenses(<<~RUBY)
        'str'[3..]
      RUBY
    end

    it 'does not registers an offense when using `[]` with endless range for interpolated string literal' do
      expect_no_offenses(<<~'RUBY')
        "string#{interpolation}"[3..]
      RUBY
    end

    it 'does not registers an offense when using `[]` with endless range for backquote string literal' do
      expect_no_offenses(<<~RUBY)
        `str`[3..]
      RUBY
    end
  end
end
