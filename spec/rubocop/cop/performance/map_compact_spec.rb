# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Performance::MapCompact, :config do
  context 'TargetRubyVersion >= 2.7', :ruby27 do
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

  context 'TargetRubyVersion <= 2.6', :ruby26 do
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
