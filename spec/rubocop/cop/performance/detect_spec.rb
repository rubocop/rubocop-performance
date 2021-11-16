# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Performance::Detect, :config do
  let(:collection_method) { nil }
  let(:config) do
    RuboCop::Config.new(
      'Style/CollectionMethods' => {
        'PreferredMethods' => {
          'detect' => collection_method
        }
      }
    )
  end

  # rspec will not let you use a variable assigned using let outside
  # of `it`
  select_methods = %i[select find_all filter].freeze

  select_methods.each do |method|
    it "registers an offense and corrects when first is called on #{method}" do
      expect_offense(<<~RUBY, method: method)
        [1, 2, 3].#{method} { |i| i % 2 == 0 }.first
                  ^{method}^^^^^^^^^^^^^^^^^^^^^^^^^ Use `detect` instead of `#{method}.first`.
      RUBY

      expect_correction(<<~RUBY)
        [1, 2, 3].detect { |i| i % 2 == 0 }
      RUBY
    end

    it "doesn't register an offense when first(n) is called on #{method}" do
      expect_no_offenses("[1, 2, 3].#{method} { |i| i % 2 == 0 }.first(n)")
    end

    it "registers an offense and corrects when last is called on #{method}" do
      expect_offense(<<~RUBY, method: method)
        [1, 2, 3].#{method} { |i| i % 2 == 0 }.last
                  ^{method}^^^^^^^^^^^^^^^^^^^^^^^^ Use `reverse.detect` instead of `#{method}.last`.
      RUBY

      expect_correction(<<~RUBY)
        [1, 2, 3].reverse.detect { |i| i % 2 == 0 }
      RUBY
    end

    it "doesn't register an offense when last(n) is called on #{method}" do
      expect_no_offenses("[1, 2, 3].#{method} { |i| i % 2 == 0 }.last(n)")
    end

    it "registers an offense and corrects when first is called on multiline #{method}" do
      expect_offense(<<~RUBY, method: method)
        [1, 2, 3].#{method} do |i|
                  ^{method}^^^^^^^ Use `detect` instead of `#{method}.first`.
          i % 2 == 0
        end.first
      RUBY

      expect_correction(<<~RUBY)
        [1, 2, 3].detect do |i|
          i % 2 == 0
        end
      RUBY
    end

    it "registers an offense when last is called on multiline #{method}" do
      expect_offense(<<~RUBY, method: method)
        [1, 2, 3].#{method} do |i|
                  ^{method}^^^^^^^ Use `reverse.detect` instead of `#{method}.last`.
          i % 2 == 0
        end.last
      RUBY

      expect_correction(<<~RUBY)
        [1, 2, 3].reverse.detect do |i|
          i % 2 == 0
        end
      RUBY
    end

    it "registers an offense when first is called on #{method} short syntax" do
      expect_offense(<<~RUBY, method: method)
        [1, 2, 3].#{method}(&:even?).first
                  ^{method}^^^^^^^^^^^^^^^ Use `detect` instead of `#{method}.first`.
      RUBY

      expect_correction(<<~RUBY)
        [1, 2, 3].detect(&:even?)
      RUBY
    end

    it "registers an offense when last is called on #{method} short syntax" do
      expect_offense(<<~RUBY, method: method)
        [1, 2, 3].#{method}(&:even?).last
                  ^{method}^^^^^^^^^^^^^^ Use `reverse.detect` instead of `#{method}.last`.
      RUBY

      expect_correction(<<~RUBY)
        [1, 2, 3].reverse.detect(&:even?)
      RUBY
    end

    it "registers an offense with #{method} short syntax and [0]" do
      expect_offense(<<~RUBY, method: method)
        [1, 2, 3].#{method}(&:even?)[0]
                  ^{method}^^^^^^^^^^^^ Use `detect` instead of `#{method}[0]`.
      RUBY

      expect_correction(<<~RUBY)
        [1, 2, 3].detect(&:even?)
      RUBY
    end

    it "registers an offense with #{method} short syntax and [-1]" do
      expect_offense(<<~RUBY, method: method)
        [1, 2, 3].#{method}(&:even?)[-1]
                  ^{method}^^^^^^^^^^^^^ Use `reverse.detect` instead of `#{method}[-1]`.
      RUBY

      expect_correction(<<~RUBY)
        [1, 2, 3].reverse.detect(&:even?)
      RUBY
    end

    it "registers an offense when #{method} is called on `lazy` without receiver" do
      expect_offense(<<~RUBY, method: method)
        lazy.#{method}(&:even?).first
             ^{method}^^^^^^^^^^^^^^^ Use `detect` instead of `#{method}.first`.
      RUBY

      expect_correction(<<~RUBY)
        lazy.detect(&:even?)
      RUBY
    end

    it "registers an offense and corrects when [0] is called on #{method}" do
      expect_offense(<<~RUBY, method: method)
        [1, 2, 3].#{method} { |i| i % 2 == 0 }[0]
                  ^{method}^^^^^^^^^^^^^^^^^^^^^^ Use `detect` instead of `#{method}[0]`.
      RUBY

      expect_correction(<<~RUBY)
        [1, 2, 3].detect { |i| i % 2 == 0 }
      RUBY
    end

    it "registers an offense and corrects when [-1] is called on #{method}" do
      expect_offense(<<~RUBY, method: method)
        [1, 2, 3].#{method} { |i| i % 2 == 0 }[-1]
                  ^{method}^^^^^^^^^^^^^^^^^^^^^^^ Use `reverse.detect` instead of `#{method}[-1]`.
      RUBY

      expect_correction(<<~RUBY)
        [1, 2, 3].reverse.detect { |i| i % 2 == 0 }
      RUBY
    end

    it "does not register an offense when #{method} is used without first or last" do
      expect_no_offenses("[1, 2, 3].#{method} { |i| i % 2 == 0 }")
    end

    it "does not register an offense when #{method} is called without block or args" do
      expect_no_offenses("adapter.#{method}.first")
    end

    it "does not register an offense when #{method} is called" \
       'with args but without ampersand syntax' do
      expect_no_offenses("adapter.#{method}('something').first")
    end

    it "does not register an offense when #{method} is called on lazy enumerable" do
      expect_no_offenses("adapter.lazy.#{method} { 'something' }.first")
    end
  end

  it 'does not register an offense when detect is used' do
    expect_no_offenses('[1, 2, 3].detect { |i| i % 2 == 0 }')
  end

  context 'autocorrect' do
    shared_examples 'detect_autocorrect' do |preferred_method|
      context "with #{preferred_method}" do
        let(:collection_method) { preferred_method }

        select_methods.each do |method|
          it "corrects #{method}.first to #{preferred_method} (multiline)" do
            expect_offense(<<~RUBY, method: method)
              [1, 2, 3].#{method} do |i|
                        ^{method}^^^^^^^ Use `#{preferred_method}` instead of `#{method}.first`.
                i % 2 == 0
              end.first
            RUBY

            expect_correction(<<~RUBY)
              [1, 2, 3].#{preferred_method} do |i|
                i % 2 == 0
              end
            RUBY
          end

          it "corrects #{method}.last to reverse.#{preferred_method} (multiline)" do
            expect_offense(<<~RUBY, method: method)
              [1, 2, 3].#{method} do |i|
                        ^{method}^^^^^^^ Use `reverse.#{preferred_method}` instead of `#{method}.last`.
                i % 2 == 0
              end.last
            RUBY

            expect_correction(<<~RUBY)
              [1, 2, 3].reverse.#{preferred_method} do |i|
                i % 2 == 0
              end
            RUBY
          end

          it "corrects multiline #{method} to #{preferred_method} with 'first' on the last line" do
            expect_offense(<<~RUBY, method: method)
              [1, 2, 3].#{method} { true }
                        ^{method}^^^^^^^^^ Use `#{preferred_method}` instead of `#{method}.first`.
              .first['x']
            RUBY

            expect_correction(<<~RUBY)
              [1, 2, 3].#{preferred_method} { true }['x']
            RUBY
          end

          it "corrects multiline #{method} to #{preferred_method} " \
             "with 'first' on the last line (short syntax)" do
            expect_offense(<<~RUBY, method: method)
              [1, 2, 3].#{method}(&:blank?)
                        ^{method}^^^^^^^^^^ Use `#{preferred_method}` instead of `#{method}.first`.
              .first['x']
            RUBY

            expect_correction(<<~RUBY)
              [1, 2, 3].#{preferred_method}(&:blank?)['x']
            RUBY
          end
        end
      end
    end

    it_behaves_like 'detect_autocorrect', 'detect'
    it_behaves_like 'detect_autocorrect', 'find'
  end

  context 'with `SequelCompatibilityMode: true`' do
    let(:config) do
      RuboCop::Config.new(
        'Performance/Detect' => {
          'SequelCompatibilityMode' => true
        },
        'Style/CollectionMethods' => {
          'PreferredMethods' => {
            'detect' => collection_method
          }
        }
      )
    end

    it 'does not register an offense when select is used and the block does not have any block arguments (inline)' do
      expect_no_offenses(<<~RUBY)
        # SQL query using the `sequel` gem
        row = connection[:my_table].select { sum(nominal_value).as(total_nominal_value) }.first
      RUBY
    end

    it 'does not register an offense when select is used and the block does not have any block arguments (multiline)' do
      expect_no_offenses(<<~RUBY)
        # SQL query using the `sequel` gem
        row = connection[:my_table].select do
          sum(nominal_value).as(total_nominal_value)
        end.first
      RUBY
    end

    it 'registers an offense when select is used and the block takes arguments (inline)' do
      expect_offense(<<~RUBY)
        array.select { |x| interesting?(x) }.first
              ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use `detect` instead of `select.first`.
      RUBY
    end

    it 'registers an offense when select is used and the block takes arguments (multiline)' do
      expect_offense(<<~RUBY)
        array.select do |x|
              ^^^^^^^^^^^^^ Use `detect` instead of `select.first`.
          interesting?(x)
        end.first
      RUBY
    end
  end
end
