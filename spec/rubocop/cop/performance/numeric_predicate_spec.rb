# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Performance::NumericPredicate, :config do
  let(:message) { RuboCop::Cop::Performance::NumericPredicate::MSG }

  shared_examples 'common functionality' do |method, op|
    it 'for integer' do
      expect_offense(<<~RUBY, method: method)
        1.#{method}
        ^^^{method} Use compare operator `1 #{op} 0` instead of `1.#{method}`.
      RUBY

      expect_correction(<<~RUBY)
        1 #{op} 0
      RUBY
    end

    it 'for float' do
      expect_offense(<<~RUBY, method: method)
        1.2.#{method}
        ^^^^^{method} Use compare operator `1.2 #{op} 0.0` instead of `1.2.#{method}`.
      RUBY

      expect_correction(<<~RUBY)
        1.2 #{op} 0.0
      RUBY
    end

    it 'ignore big decimal' do
      next if method == 'zero?'

      expect_offense(<<~RUBY, method: method)
        BigDecimal('1', 2).#{method}
        ^^^^^^^^^^^^^^^^^^^^{method} Use compare operator `BigDecimal('1', 2) #{op} 0` instead of `BigDecimal('1', 2).#{method}`.
      RUBY

      expect_correction(<<~RUBY)
        BigDecimal('1', 2) #{op} 0
      RUBY
    end

    it 'for variable' do
      next if method == 'zero?'

      expect_offense(<<~RUBY, method: method)
        foo = 1
        foo.#{method}
        ^^^^^{method} Use compare operator `foo #{op} 0` instead of `foo.#{method}`.
      RUBY

      expect_correction(<<~RUBY)
        foo = 1
        foo #{op} 0
      RUBY
    end

    it 'in condition statements' do
      next if method == 'zero?'

      expect_offense(<<~RUBY, method: method)
        foo = 1
        if foo.#{method}
           ^^^^^{method} Use compare operator `foo #{op} 0` instead of `foo.#{method}`.
        end
      RUBY

      expect_correction(<<~RUBY)
        foo = 1
        if foo #{op} 0
        end
      RUBY
    end

    it 'in map statement' do
      next if method == 'zero?'

      expect_no_offenses(<<~RUBY, method: method)
        foo = [1, 2, 3]
        if foo.all?(&:#{method})
        end
      RUBY
    end
  end

  it_behaves_like 'common functionality', 'positive?', '>'
  it_behaves_like 'common functionality', 'negative?', '<'
  it_behaves_like 'common functionality', 'zero?', '=='
end
