# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Performance::ChainArrayAllocation, :config do
  describe 'Methods that require an argument' do
    it 'does not register an offense for `first.uniq`' do
      # Yes I know this is not valid Ruby
      expect_no_offenses(<<~RUBY)
        [1, 2, 3, 4].first.uniq
      RUBY
    end

    it 'registers an offense for `first(10).uniq`' do
      expect_offense(<<~RUBY)
        [1, 2, 3, 4].first(10).uniq
                               ^^^^ Use unchained `first` and `uniq!` (followed by `return array` if required) instead of chaining `first...uniq`.
      RUBY
    end

    it 'registers an offense for `first(variable).uniq`' do
      expect_offense(<<~RUBY)
        variable = 42
        [1, 2, 3, 4].first(variable).uniq
                                     ^^^^ Use unchained `first` and `uniq!` (followed by `return array` if required) instead of chaining `first...uniq`.
      RUBY
    end

    it 'registers an offense for `first(do_something).uniq`' do
      expect_offense(<<~RUBY)
        [1, 2, 3, 4].first(do_something).uniq
                                         ^^^^ Use unchained `first` and `uniq!` (followed by `return array` if required) instead of chaining `first...uniq`.
      RUBY
    end
  end

  describe 'methods that only return an array with no block' do
    it 'zip' do
      # Yes I know this is not valid Ruby
      expect_no_offenses(<<~RUBY)
        [1, 2, 3, 4].zip {|f| }.uniq
      RUBY

      expect_offense(<<~RUBY)
        [1, 2, 3, 4].zip {|f| }.zip.uniq
                                    ^^^^ Use unchained `zip` and `uniq!` (followed by `return array` if required) instead of chaining `zip...uniq`.
      RUBY
    end
  end

  describe 'when using `Enumerable#lazy`' do
    it 'does not register an offense' do
      expect_no_offenses(<<~RUBY)
        some_array.lazy.map(&:some_obj_method).reject(&:nil?).first
      RUBY
    end
  end

  describe 'when using `select` with block argument after `select` with positional arguments' do
    it 'does not register an offense' do
      expect_no_offenses(<<~RUBY)
        model.select(:foo, :bar).select { |item| item.do_something }
      RUBY
    end
  end

  describe 'when using `select` with block argument after `select` with block argument' do
    it 'registers an offense' do
      expect_offense(<<~RUBY)
        model.select { |item| item.foo }.select { |item| item.bar }
                                         ^^^^^^ Use unchained `select` and `select!` (followed by `return array` if required) instead of chaining `select...select`.
      RUBY
    end
  end

  describe 'when using `select` with block argument after `select` with numbered block argument' do
    it 'registers an offense' do
      expect_offense(<<~RUBY)
        model.select { _1.foo }.select { |item| item.bar }
                                ^^^^^^ Use unchained `select` and `select!` (followed by `return array` if required) instead of chaining `select...select`.
      RUBY
    end
  end

  describe 'when using `select` with block argument after `select` with `it` block', :ruby34, unsupported_on: :parser do
    it 'registers an offense' do
      expect_offense(<<~RUBY)
        model.select { it.foo }.select { |item| item.bar }
                                ^^^^^^ Use unchained `select` and `select!` (followed by `return array` if required) instead of chaining `select...select`.
      RUBY
    end
  end

  describe 'when using `select` with positional arguments after `select`' do
    it 'does not register an offense' do
      expect_no_offenses(<<~RUBY)
        model.select(:foo, :bar).select(:baz, :qux)
      RUBY
    end
  end
end
