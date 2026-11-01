# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Performance::ChainedHashMerge, :config do
  context 'when TargetRubyVersion >= 2.6', :ruby26 do
    it 'registers an offense and corrects when using chained `merge`' do
      expect_offense(<<~RUBY)
        hash.merge(a).merge(b)
             ^^^^^^^^^^^^^^^^^ Use `merge(a, b)` instead of chained `merge` calls.
      RUBY

      expect_correction(<<~RUBY)
        hash.merge(a, b)
      RUBY
    end

    it 'registers an offense and corrects when using chained `merge` repeated three times' do
      expect_offense(<<~RUBY)
        hash.merge(a).merge(b).merge(c)
             ^^^^^^^^^^^^^^^^^^^^^^^^^^ Use `merge(a, b, c)` instead of chained `merge` calls.
      RUBY

      expect_correction(<<~RUBY)
        hash.merge(a, b, c)
      RUBY
    end

    it 'registers an offense and corrects when the calls take multiple arguments' do
      expect_offense(<<~RUBY)
        hash.merge(a, b).merge(c, d)
             ^^^^^^^^^^^^^^^^^^^^^^^ Use `merge(a, b, c, d)` instead of chained `merge` calls.
      RUBY

      expect_correction(<<~RUBY)
        hash.merge(a, b, c, d)
      RUBY
    end

    it 'registers an offense and corrects when using safe navigation' do
      expect_offense(<<~RUBY)
        hash&.merge(a).merge(b)
              ^^^^^^^^^^^^^^^^^ Use `merge(a, b)` instead of chained `merge` calls.
      RUBY

      expect_correction(<<~RUBY)
        hash&.merge(a, b)
      RUBY
    end

    it 'registers an offense and corrects when there is no receiver' do
      expect_offense(<<~RUBY)
        merge(a).merge(b)
        ^^^^^^^^^^^^^^^^^ Use `merge(a, b)` instead of chained `merge` calls.
      RUBY

      expect_correction(<<~RUBY)
        merge(a, b)
      RUBY
    end

    it 'registers an offense and corrects when the chain spans multiple lines' do
      expect_offense(<<~RUBY)
        hash.merge(a)
             ^^^^^^^^ Use `merge(a, b)` instead of chained `merge` calls.
            .merge(b)
      RUBY

      expect_correction(<<~RUBY)
        hash.merge(a, b)
      RUBY
    end

    it 'registers an offense and corrects when braceless hash arguments are not in the last position' do
      expect_offense(<<~RUBY)
        hash.merge(a: 1).merge(b).merge(c: 3)
             ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use `merge({ a: 1 }, b, c: 3)` instead of chained `merge` calls.
      RUBY

      expect_correction(<<~RUBY)
        hash.merge({ a: 1 }, b, c: 3)
      RUBY
    end

    it 'registers an offense and corrects when the chain is the receiver of another method call' do
      expect_offense(<<~RUBY)
        hash.merge(a).merge(b).keys
             ^^^^^^^^^^^^^^^^^ Use `merge(a, b)` instead of chained `merge` calls.
      RUBY

      expect_correction(<<~RUBY)
        hash.merge(a, b).keys
      RUBY
    end

    it 'does not register an offense when using a single `merge`' do
      expect_no_offenses(<<~RUBY)
        hash.merge(a)
      RUBY
    end

    it 'does not register an offense when another method call breaks the chain' do
      expect_no_offenses(<<~RUBY)
        hash.merge(a).to_h.merge(b)
      RUBY
    end

    it 'does not register an offense when using chained `merge!` or `update`' do
      expect_no_offenses(<<~RUBY)
        hash.merge!(a).merge!(b)
        hash.update(a).update(b)
      RUBY
    end

    it 'does not register an offense when a call in the chain takes a block' do
      expect_no_offenses(<<~RUBY)
        hash.merge(a) { |key, old, new| old }.merge(b)
      RUBY
    end

    it 'does not register an offense when the last call takes a block' do
      expect_no_offenses(<<~RUBY)
        hash.merge(a).merge(b) { |key, old, new| old }
      RUBY
    end

    it 'does not register an offense when a call in the chain takes a block argument' do
      expect_no_offenses(<<~RUBY)
        hash.merge(a, &block).merge(b)
      RUBY
    end

    it 'does not register an offense when a call in the chain takes no arguments' do
      expect_no_offenses(<<~RUBY)
        hash.merge.merge(b)
      RUBY
    end

    it 'does not register an offense when an argument contains a heredoc' do
      expect_no_offenses(<<~RUBY)
        hash.merge(key => <<~TEXT).merge(b)
          text
        TEXT
      RUBY
    end
  end

  context 'when TargetRubyVersion <= 2.5', :ruby25, unsupported_on: :prism do
    it 'does not register an offense when using chained `merge`' do
      expect_no_offenses(<<~RUBY)
        hash.merge(a).merge(b)
      RUBY
    end
  end
end
