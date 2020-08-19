# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Performance::Count do
  subject(:cop) { described_class.new }

  shared_examples 'selectors' do |selector|
    it "registers an offense for using array.#{selector}...size" do
      expect_offense(<<~RUBY, selector: selector)
        [1, 2, 3].#{selector} { |e| e.even? }.size
                  ^{selector}^^^^^^^^^^^^^^^^^^^^^ Use `count` instead of `#{selector}...size`.
      RUBY
    end

    it "registers an offense for using hash.#{selector}...size" do
      expect_offense(<<~RUBY, selector: selector)
        {a: 1, b: 2, c: 3}.#{selector} { |e| e == :a }.size
                           ^{selector}^^^^^^^^^^^^^^^^^^^^^ Use `count` instead of `#{selector}...size`.
      RUBY
    end

    it "registers an offense for using array.#{selector}...length" do
      expect_offense(<<~RUBY, selector: selector)
        [1, 2, 3].#{selector} { |e| e.even? }.length
                  ^{selector}^^^^^^^^^^^^^^^^^^^^^^^ Use `count` instead of `#{selector}...length`.
      RUBY
    end

    it "registers an offense for using hash.#{selector}...length" do
      expect_offense(<<~RUBY, selector: selector)
        {a: 1, b: 2}.#{selector} { |e| e == :a }.length
                     ^{selector}^^^^^^^^^^^^^^^^^^^^^^^ Use `count` instead of `#{selector}...length`.
      RUBY
    end

    it "registers an offense for using array.#{selector}...count" do
      expect_offense(<<~RUBY, selector: selector)
        [1, 2, 3].#{selector} { |e| e.even? }.count
                  ^{selector}^^^^^^^^^^^^^^^^^^^^^^ Use `count` instead of `#{selector}...count`.
      RUBY
    end

    it "registers an offense for using hash.#{selector}...count" do
      expect_offense(<<~RUBY, selector: selector)
        {a: 1, b: 2}.#{selector} { |e| e == :a }.count
                     ^{selector}^^^^^^^^^^^^^^^^^^^^^^ Use `count` instead of `#{selector}...count`.
      RUBY
    end

    it "allows usage of #{selector}...count with a block on an array" do
      expect_no_offenses(<<~RUBY)
        [1, 2, 3].#{selector} { |e| e.odd? }.count { |e| e > 2 }
      RUBY
    end

    it "allows usage of #{selector}...count with a block on a hash" do
      expect_no_offenses(<<~RUBY)
        {a: 1, b: 2}.#{selector} { |e| e == :a }.count { |e| e > 2 }
      RUBY
    end

    it "registers an offense for #{selector} with params instead of a block" do
      expect_offense(<<~RUBY, selector: selector)
        Data = Struct.new(:value)
        array = [Data.new(2), Data.new(3), Data.new(2)]
        puts array.#{selector}(&:value).count
                   ^{selector}^^^^^^^^^^^^^^^ Use `count` instead of `#{selector}...count`.
      RUBY
    end

    it "registers an offense for #{selector}(&:something).count" do
      expect_offense(<<~RUBY, selector: selector)
        foo.#{selector}(&:something).count
            ^{selector}^^^^^^^^^^^^^^^^^^^ Use `count` instead of `#{selector}...count`.
      RUBY
    end

    it "registers an offense for #{selector}(&:something).count " \
       'when called as an instance method on its own class' do
      expect_offense(<<~RUBY, selector: selector)
        class A < Array
          def count(&block)
            #{selector}(&block).count
            ^{selector}^^^^^^^^^^^^^^ Use `count` instead of `#{selector}...count`.
          end
        end
      RUBY
    end

    it "allows usage of #{selector} without getting the size" do
      expect_no_offenses("[1, 2, 3].#{selector} { |e| e.even? }")
    end

    context 'bang methods' do
      it "allows usage of #{selector}!...size" do
        expect_no_offenses("[1, 2, 3].#{selector}! { |e| e.odd? }.size")
      end

      it "allows usage of #{selector}!...count" do
        expect_no_offenses("[1, 2, 3].#{selector}! { |e| e.odd? }.count")
      end

      it "allows usage of #{selector}!...length" do
        expect_no_offenses("[1, 2, 3].#{selector}! { |e| e.odd? }.length")
      end
    end
  end

  it_behaves_like('selectors', 'select')
  it_behaves_like('selectors', 'find_all')
  it_behaves_like('selectors', 'filter')
  it_behaves_like('selectors', 'reject')

  context 'Active Record select' do
    it 'allows usage of select with a string' do
      expect_no_offenses("Model.select('field AS field_one').count")
    end

    it 'allows usage of select with multiple strings' do
      expect_no_offenses(<<~RUBY)
        Model.select('field AS field_one', 'other AS field_two').count
      RUBY
    end

    it 'allows usage of select with a symbol' do
      expect_no_offenses('Model.select(:field).count')
    end

    it 'allows usage of select with multiple symbols' do
      expect_no_offenses('Model.select(:field, :other_field).count')
    end
  end

  it 'allows usage of another method with size' do
    expect_no_offenses('[1, 2, 3].map { |e| e + 1 }.size')
  end

  it 'allows usage of size on an array' do
    expect_no_offenses('[1, 2, 3].size')
  end

  it 'allows usage of count on an array' do
    expect_no_offenses('[1, 2, 3].count')
  end

  it 'allows usage of count on an interstitial method called on select' do
    expect_no_offenses(<<~RUBY)
      Data = Struct.new(:value)
      array = [Data.new(2), Data.new(3), Data.new(2)]
      puts array.select(&:value).uniq.count
    RUBY
  end

  it 'allows usage of count on an interstitial method with blocks ' \
     'called on select' do
    expect_no_offenses(<<~RUBY)
      Data = Struct.new(:value)
      array = [Data.new(2), Data.new(3), Data.new(2)]
      array.select(&:value).uniq { |v| v > 2 }.count
    RUBY
  end

  it 'allows usage of size called on an assigned variable' do
    expect_no_offenses(<<~RUBY)
      nodes = [1]
      nodes.size
    RUBY
  end

  it 'allows usage of methods called on size' do
    expect_no_offenses('shorter.size.to_f')
  end

  context 'properly parses non related code' do
    it 'will not raise an error for Bundler.setup' do
      expect { inspect_source('Bundler.setup(:default, :development)') }.not_to raise_error
    end

    it 'will not raise an error for RakeTask.new' do
      expect { inspect_source('RakeTask.new(:spec)') }.not_to raise_error
    end
  end

  context 'autocorrect' do
    context 'will correct' do
      it 'select..size to count' do
        expect_offense(<<~RUBY)
          [1, 2].select { |e| e > 2 }.size
                 ^^^^^^^^^^^^^^^^^^^^^^^^^ Use `count` instead of `select...size`.
        RUBY

        expect_correction(<<~RUBY)
          [1, 2].count { |e| e > 2 }
        RUBY
      end

      it 'select..count without a block to count' do
        expect_offense(<<~RUBY)
          [1, 2].select { |e| e > 2 }.count
                 ^^^^^^^^^^^^^^^^^^^^^^^^^^ Use `count` instead of `select...count`.
        RUBY

        expect_correction(<<~RUBY)
          [1, 2].count { |e| e > 2 }
        RUBY
      end

      it 'select..length to count' do
        expect_offense(<<~RUBY)
          [1, 2].select { |e| e > 2 }.length
                 ^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use `count` instead of `select...length`.
        RUBY

        expect_correction(<<~RUBY)
          [1, 2].count { |e| e > 2 }
        RUBY
      end

      it 'select...size when select has parameters' do
        expect_offense(<<~RUBY)
          Data = Struct.new(:value)
          array = [Data.new(2), Data.new(3), Data.new(2)]
          puts array.select(&:value).size
                     ^^^^^^^^^^^^^^^^^^^^ Use `count` instead of `select...size`.
        RUBY

        expect_correction(<<~RUBY)
          Data = Struct.new(:value)
          array = [Data.new(2), Data.new(3), Data.new(2)]
          puts array.count(&:value)
        RUBY
      end
    end

    describe 'will not correct' do
      it 'reject...size' do
        expect_offense(<<~RUBY)
          [1, 2].reject { |e| e > 2 }.size
                 ^^^^^^^^^^^^^^^^^^^^^^^^^ Use `count` instead of `reject...size`.
        RUBY

        expect_correction(<<~RUBY)
          [1, 2].reject { |e| e > 2 }.size
        RUBY
      end

      it 'reject...count' do
        expect_offense(<<~RUBY)
          [1, 2].reject { |e| e > 2 }.count
                 ^^^^^^^^^^^^^^^^^^^^^^^^^^ Use `count` instead of `reject...count`.
        RUBY

        expect_correction(<<~RUBY)
          [1, 2].reject { |e| e > 2 }.count
        RUBY
      end

      it 'reject...length' do
        expect_offense(<<~RUBY)
          [1, 2].reject { |e| e > 2 }.length
                 ^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use `count` instead of `reject...length`.
        RUBY

        expect_correction(<<~RUBY)
          [1, 2].reject { |e| e > 2 }.length
        RUBY
      end

      it 'select...count when count has a block' do
        expect_no_offenses(<<~RUBY)
          [1, 2].select { |e| e > 2 }.count { |e| e.even? }
        RUBY
      end

      it 'reject...size when select has parameters' do
        expect_offense(<<~RUBY)
          Data = Struct.new(:value)
          array = [Data.new(2), Data.new(3), Data.new(2)]
          puts array.reject(&:value).size
                     ^^^^^^^^^^^^^^^^^^^^ Use `count` instead of `reject...size`.
        RUBY

        expect_no_corrections
      end
    end
  end
end
