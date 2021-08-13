# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Performance::MapCompact, :config do
  context 'when TargetRubyVersion >= 2.7', :ruby27 do
    it 'registers an offense when using `collection.map(&:do_something).compact`' do
      expect_offense(<<~RUBY)
        collection.map(&:do_something).compact
                   ^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use `filter_map` instead.
      RUBY

      expect_correction(<<~RUBY)
        collection.filter_map(&:do_something)
      RUBY
    end

    it 'registers an offense when using `collection.map { |item| item.do_something }.compact`' do
      expect_offense(<<~RUBY)
        collection.map { |item| item.do_something }.compact
                   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use `filter_map` instead.
      RUBY

      expect_correction(<<~RUBY)
        collection.filter_map { |item| item.do_something }
      RUBY
    end

    it 'registers an offense when using `collection.collect(&:do_something).compact`' do
      expect_offense(<<~RUBY)
        collection.collect(&:do_something).compact
                   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use `filter_map` instead.
      RUBY

      expect_correction(<<~RUBY)
        collection.filter_map(&:do_something)
      RUBY
    end

    it 'registers an offense when using `collection.collect { |item| item.do_something }.compact`' do
      expect_offense(<<~RUBY)
        collection.collect { |item| item.do_something }.compact
                   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use `filter_map` instead.
      RUBY

      expect_correction(<<~RUBY)
        collection.filter_map { |item| item.do_something }
      RUBY
    end

    it 'registers an offense when using `map.compact.first` with single-line method calls' do
      expect_offense(<<~RUBY)
        collection.map { |item| item.do_something }.compact.first
                   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use `filter_map` instead.
      RUBY

      expect_correction(<<~RUBY)
        collection.filter_map { |item| item.do_something }.first
      RUBY
    end

    it 'registers an offense when using `map.compact.first` with multi-line leading dot method calls' do
      expect_offense(<<~RUBY)
        collection
          .map { |item| item.do_something }
           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use `filter_map` instead.
          .compact
          .first
      RUBY

      expect_correction(<<~RUBY)
        collection
          .filter_map { |item| item.do_something }
          .first
      RUBY
    end

    it 'registers an offense when using `map.compact.first` with multi-line trailing dot method calls' do
      expect_offense(<<~RUBY)
        collection.
          map { |item| item.do_something }.
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use `filter_map` instead.
          compact.
          first
      RUBY

      expect_correction(<<~RUBY)
        collection.
          filter_map { |item| item.do_something }.
          first
      RUBY
    end

    it 'registers an offense when using `map.compact.first` and there is a line break after `map.compact`' do
      expect_offense(<<~RUBY)
        collection.map { |item| item.do_something }.compact
                   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use `filter_map` instead.
          .first
      RUBY

      expect_correction(<<~RUBY)
        collection.filter_map { |item| item.do_something }
          .first
      RUBY
    end

    it 'registers an offense when using `map { ... }.compact`' do
      expect_offense(<<~RUBY)
        collection.map { |item|
                   ^^^^^^^^^^^^ Use `filter_map` instead.
        }.compact
      RUBY

      expect_correction(<<~RUBY)
        collection.filter_map { |item|
        }
      RUBY
    end

    it 'registers an offense when invoking a method after `map { ... }.compact`' do
      expect_offense(<<~RUBY)
        collection.map { |item|
                   ^^^^^^^^^^^^ Use `filter_map` instead.
        }.compact.do_something
      RUBY

      expect_correction(<<~RUBY)
        collection.filter_map { |item|
        }.do_something
      RUBY
    end

    it 'registers an offense when using multi-line `collection.map { ... }.compact` as a method argument' do
      expect_offense(<<~RUBY)
        do_something(
          collection.map { |item|
                     ^^^^^^^^^^^^ Use `filter_map` instead.
          }.compact
        )
      RUBY

      expect_correction(<<~RUBY)
        do_something(
          collection.filter_map { |item|
          }
        )
      RUBY
    end

    it 'registers an offense when using multiline `map { ... }.compact` and assigning to return value' do
      expect_offense(<<~RUBY)
        ret = collection.map do |item|
                         ^^^^^^^^^^^^^ Use `filter_map` instead.
        end.compact
      RUBY

      expect_correction(<<~RUBY)
        ret = collection.filter_map do |item|
        end
      RUBY
    end

    it 'does not register an offense when using `collection.map(&:do_something).compact!`' do
      expect_no_offenses(<<~RUBY)
        collection.map(&:do_something).compact!
      RUBY
    end

    it 'does not register an offense when using `collection.map { |item| item.do_something }.compact!`' do
      expect_no_offenses(<<~RUBY)
        collection.map { |item| item.do_something }.compact!
      RUBY
    end

    it 'does not register an offense when using `collection.collect(&:do_something).compact!`' do
      expect_no_offenses(<<~RUBY)
        collection.collect(&:do_something).compact!
      RUBY
    end

    it 'does not register an offense when using `collection.collect { |item| item.do_something }.compact!`' do
      expect_no_offenses(<<~RUBY)
        collection.collect { |item| item.do_something }.compact!
      RUBY
    end

    it 'does not register an offense when using `collection.compact.map(&:do_something)`' do
      expect_no_offenses(<<~RUBY)
        collection.compact.map(&:do_something)
      RUBY
    end

    it 'does not register an offense when using `collection.not_map_method(&:do_something).compact`' do
      expect_no_offenses(<<~RUBY)
        collection.not_map_method(&:do_something).compact
      RUBY
    end

    it 'does not register an offense when using `collection.filter_map(&:do_something)`' do
      expect_no_offenses(<<~RUBY)
        collection.filter_map(&:do_something)
      RUBY
    end
  end

  context 'when TargetRubyVersion <= 2.6', :ruby26 do
    it 'does not register an offense when using `collection.map(&:do_something).compact`' do
      expect_no_offenses(<<~RUBY)
        collection.map(&:do_something).compact
      RUBY
    end

    it 'does not register an offense when using `collection.map { |item| item.do_something }.compact`' do
      expect_no_offenses(<<~RUBY)
        collection.map { |item| item.do_something }.compact
      RUBY
    end
  end
end
