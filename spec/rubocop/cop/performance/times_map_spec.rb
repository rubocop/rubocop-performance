# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Performance::TimesMap, :config do
  shared_examples 'map_or_collect' do |method|
    describe ".times.#{method}" do
      context 'with a block' do
        it 'registers an offense and corrects' do
          expect_offense(<<~RUBY, method: method)
            4.times.#{method} { |i| i.to_s }
            ^^^^^^^^^{method}^^^^^^^^^^^^^^^ Use `Array.new(4)` with a block instead of `.times.#{method}`.
          RUBY

          expect_correction(<<~RUBY)
            Array.new(4) { |i| i.to_s }
          RUBY
        end
      end

      context 'with a block with safe navigation call' do
        it 'registers an offense and corrects' do
          expect_offense(<<~RUBY, method: method)
            4&.times&.#{method} { |i| i.to_s }
            ^^^^^^^^^^^{method}^^^^^^^^^^^^^^^ Use `Array.new(4)` with a block instead of `.times.#{method}`.
          RUBY

          expect_correction(<<~RUBY)
            Array.new(4) { |i| i.to_s }
          RUBY
        end
      end

      context 'with a block with safe navigation call for integer literal' do
        it 'registers an offense and corrects' do
          expect_offense(<<~RUBY, method: method)
            42&.times&.#{method} { |i| i.to_s }
            ^^^^^^^^^^^^{method}^^^^^^^^^^^^^^^ Use `Array.new(42)` with a block instead of `.times.#{method}`.
          RUBY
        end
      end

      context 'with a block with safe navigation call for float literal' do
        it 'registers an offense and corrects' do
          expect_offense(<<~RUBY, method: method)
            4.2&.times&.#{method} { |i| i.to_s }
            ^^^^^^^^^^^^^{method}^^^^^^^^^^^^^^^ Use `Array.new(4.2)` with a block instead of `.times.#{method}`.
          RUBY
        end
      end

      context 'with a block with safe navigation call for nil literal' do
        it 'does not register an offense' do
          expect_no_offenses(<<~RUBY, method: method)
            nil&.times&.#{method} { |i| i.to_s }
          RUBY
        end
      end

      context 'with a block with safe navigation call for local variable' do
        it 'does not register an offense' do
          expect_no_offenses(<<~RUBY, method: method)
            nullable&.times&.#{method} { |i| i.to_s }
          RUBY
        end
      end

      context 'with a block with safe navigation call for instance variable' do
        it 'does not register an offense' do
          expect_no_offenses(<<~RUBY, method: method)
            @nullable&.times&.#{method} { |i| i.to_s }
          RUBY
        end
      end

      context 'for non-literal receiver' do
        it 'registers an offense' do
          expect_offense(<<~RUBY, method: method)
            n.times.#{method} { |i| i.to_s }
            ^^^^^^^^^{method}^^^^^^^^^^^^^^^ Use `Array.new(n)` with a block instead of `.times.#{method}` only if `n` is always 0 or more.
          RUBY

          expect_correction(<<~RUBY)
            Array.new(n) { |i| i.to_s }
          RUBY
        end
      end

      context 'with an explicitly passed block' do
        it 'registers an offense and corrects' do
          expect_offense(<<~RUBY, method: method)
            4.times.#{method}(&method(:foo))
            ^^^^^^^^^{method}^^^^^^^^^^^^^^^ Use `Array.new(4)` with a block instead of `.times.#{method}`.
          RUBY

          expect_correction(<<~RUBY)
            Array.new(4, &method(:foo))
          RUBY
        end
      end

      context 'with an explicitly passed block with safe navigation call' do
        it 'registers an offense and corrects' do
          expect_offense(<<~RUBY, method: method)
            4&.times&.#{method}(&method(:foo))
            ^^^^^^^^^^^{method}^^^^^^^^^^^^^^^ Use `Array.new(4)` with a block instead of `.times.#{method}`.
          RUBY

          expect_correction(<<~RUBY)
            Array.new(4, &method(:foo))
          RUBY
        end
      end

      context 'without a block' do
        it "doesn't register an offense" do
          expect_no_offenses(<<~RUBY)
            4.times.#{method}
          RUBY
        end
      end

      context 'called on nothing' do
        it "doesn't register an offense" do
          expect_no_offenses(<<~RUBY)
            times.#{method} { |i| i.to_s }
          RUBY
        end
      end

      context 'when using numbered parameter', :ruby27 do
        it 'registers an offense and corrects' do
          expect_offense(<<~RUBY, method: method)
            4.times.#{method} { _1.to_s }
            ^^^^^^^^^{method}^^^^^^^^^^^^ Use `Array.new(4)` with a block instead of `.times.#{method}`.
          RUBY

          expect_correction(<<~RUBY)
            Array.new(4) { _1.to_s }
          RUBY
        end
      end
    end
  end

  it_behaves_like 'map_or_collect', 'map'
  it_behaves_like 'map_or_collect', 'collect'
end
