# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Performance::CompareWithBlock, :config do
  shared_examples 'compare with block' do |method|
    it "registers an offense and corrects for #{method}" do
      expect_offense(<<~RUBY, method: method)
        array.#{method} { |a, b| a.foo <=> b.foo }
              ^{method}^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use `#{method}_by(&:foo)` instead of `#{method} { |a, b| a.foo <=> b.foo }`.
      RUBY

      expect_correction(<<~RUBY)
        array.#{method}_by(&:foo)
      RUBY
    end

    it "registers an offense and corrects for #{method} with [:foo]" do
      expect_offense(<<~RUBY, method: method)
        array.#{method} { |a, b| a[:foo] <=> b[:foo] }
              ^{method}^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use `#{method}_by { |a| a[:foo] }` instead of `#{method} { |a, b| a[:foo] <=> b[:foo] }`.
      RUBY

      expect_correction(<<~RUBY)
        array.#{method}_by { |a| a[:foo] }
      RUBY
    end

    it "registers an offense and corrects for #{method} with ['foo']" do
      expect_offense(<<~RUBY, method: method)
        array.#{method} { |a, b| a['foo'] <=> b['foo'] }
              ^{method}^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use `#{method}_by { |a| a['foo'] }` instead of `#{method} { |a, b| a['foo'] <=> b['foo'] }`.
      RUBY

      expect_correction(<<~RUBY)
        array.#{method}_by { |a| a['foo'] }
      RUBY
    end

    it "registers an offense and corrects for #{method} with [1]" do
      expect_offense(<<~RUBY, method: method)
        array.#{method} { |a, b| a[1] <=> b[1] }
              ^{method}^^^^^^^^^^^^^^^^^^^^^^^^^ Use `#{method}_by { |a| a[1] }` instead of `#{method} { |a, b| a[1] <=> b[1] }`.
      RUBY

      expect_correction(<<~RUBY)
        array.#{method}_by { |a| a[1] }
      RUBY
    end

    it "accepts valid #{method} usage" do
      expect_no_offenses("array.#{method} { |a, b| b <=> a }")
    end

    it "accepts #{method}_by" do
      expect_no_offenses("array.#{method}_by { |a| a.baz }")
    end
  end

  include_examples 'compare with block', 'sort'
  include_examples 'compare with block', 'max'
  include_examples 'compare with block', 'min'
end
