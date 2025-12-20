# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Performance::CompareWithBlock, :config do
  shared_examples 'compare with block' do |method, replacement|
    it "registers an offense and corrects for #{method}" do
      expect_offense(<<~RUBY, method: method)
        array.#{method} { |a, b| a.foo <=> b.foo }
              ^{method}^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use `#{replacement}(&:foo)` instead of `#{method} { |a, b| a.foo <=> b.foo }`.
      RUBY

      expect_correction(<<~RUBY)
        array.#{replacement}(&:foo)
      RUBY
    end

    it "registers an offense and corrects for #{method} with [:foo]" do
      expect_offense(<<~RUBY, method: method)
        array.#{method} { |a, b| a[:foo] <=> b[:foo] }
              ^{method}^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use `#{replacement} { |a| a[:foo] }` instead of `#{method} { |a, b| a[:foo] <=> b[:foo] }`.
      RUBY

      expect_correction(<<~RUBY)
        array.#{replacement} { |a| a[:foo] }
      RUBY
    end

    it "registers an offense and corrects for #{method} with ['foo']" do
      expect_offense(<<~RUBY, method: method)
        array.#{method} { |a, b| a['foo'] <=> b['foo'] }
              ^{method}^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use `#{replacement} { |a| a['foo'] }` instead of `#{method} { |a, b| a['foo'] <=> b['foo'] }`.
      RUBY

      expect_correction(<<~RUBY)
        array.#{replacement} { |a| a['foo'] }
      RUBY
    end

    it "registers an offense and corrects for #{method} with [1]" do
      expect_offense(<<~RUBY, method: method)
        array.#{method} { |a, b| a[1] <=> b[1] }
              ^{method}^^^^^^^^^^^^^^^^^^^^^^^^^ Use `#{replacement} { |a| a[1] }` instead of `#{method} { |a, b| a[1] <=> b[1] }`.
      RUBY

      expect_correction(<<~RUBY)
        array.#{replacement} { |a| a[1] }
      RUBY
    end

    it "accepts valid #{method} usage" do
      expect_no_offenses("array.#{method} { |a, b| b <=> a }")
    end

    it "accepts #{replacement}" do
      expect_no_offenses("array.#{replacement} { |a| a.baz }")
    end
  end

  it_behaves_like 'compare with block', 'sort',   'sort_by'
  it_behaves_like 'compare with block', 'sort!',  'sort_by!'
  it_behaves_like 'compare with block', 'max',    'max_by'
  it_behaves_like 'compare with block', 'min',    'min_by'
  it_behaves_like 'compare with block', 'minmax', 'minmax_by'
end
