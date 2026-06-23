# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Performance::ReduceMerge, :config do
  let(:message) { RuboCop::Cop::Performance::ReduceMerge::MSG }

  context 'when using `Enumerable#reduce`' do
    context 'with `Hash#merge`' do
      it 'registers an offense with an implicit hash literal argument' do
        expect_offense(<<~RUBY)
          enumerable.reduce({}) do |hash, (key, value)|
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ #{message}
            other(stuff)
            hash.merge(key => value)
          end
        RUBY

        expect_correction(<<~RUBY)
          enumerable.each_with_object({}) do |(key, value), hash|
            other(stuff)
            hash[key] = value
          end
        RUBY
      end

      it 'registers an offense with an explicit hash literal argument' do
        expect_offense(<<~RUBY)
          enumerable.reduce({}) do |hash, (key, value)|
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ #{message}
            other(stuff)
            hash.merge({ key => value })
          end
        RUBY

        expect_correction(<<~RUBY)
          enumerable.each_with_object({}) do |(key, value), hash|
            other(stuff)
            hash[key] = value
          end
        RUBY
      end

      it 'registers an offense with `Hash.new` initial value' do
        expect_offense(<<~RUBY)
          enumerable.reduce(Hash.new) do |hash, (key, value)|
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ #{message}
            other(stuff)
            hash.merge(key => value)
          end
        RUBY

        expect_correction(<<~RUBY)
          enumerable.each_with_object(Hash.new) do |(key, value), hash|
            other(stuff)
            hash[key] = value
          end
        RUBY
      end

      it 'registers no offense with `Set.new` initial value' do
        # Set#merge mutates the receiver, like Hash#merge!
        expect_no_offenses(<<~RUBY)
          enumerable.reduce(Set.new) do |set, values|
            other(stuff)
            set.merge(values)
          end
        RUBY
      end

      it 'registers an offense with many key-value pairs' do
        expect_offense(<<~RUBY)
          enumerable.reduce({}) do |hash, (key, value)|
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ #{message}
            other(stuff)
            hash.merge(key => value, another => pair)
          end
        RUBY

        expect_correction(<<~RUBY)
          enumerable.each_with_object({}) do |(key, value), hash|
            other(stuff)
            hash[key] = value
            hash[another] = pair
          end
        RUBY
      end

      it 'registers an offense with a hash variable argument' do
        expect_offense(<<~RUBY)
          enumerable.reduce({}) do |hash, element|
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ #{message}
            other(stuff)
            hash.merge(element)
          end
        RUBY

        expect_correction(<<~RUBY)
          enumerable.each_with_object({}) do |element, hash|
            other(stuff)
            hash.merge!(element)
          end
        RUBY
      end

      it 'registers an offense with multiple varied arguments' do
        expect_offense(<<~RUBY)
          enumerable.reduce({}) do |hash, element|
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ #{message}
            other(stuff)
            hash.merge({ k1 => v1, k2 => v2}, element, another_hash, {k3 => v3}, {k4 => v4}, yet_another_hash)
          end
        RUBY

        expect_correction(<<~RUBY)
          enumerable.each_with_object({}) do |element, hash|
            other(stuff)
            hash[k1] = v1
            hash[k2] = v2
            hash.merge!(element, another_hash)
            hash[k3] = v3
            hash[k4] = v4
            hash.merge!(yet_another_hash)
          end
        RUBY
      end

      it 'registers an offense with a single line block' do
        expect_offense(<<~RUBY)
          enumerable.reduce({}) { |hash, (k, v)| hash.merge(k => v) }
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ #{message}
        RUBY

        expect_correction(<<~RUBY)
          enumerable.each_with_object({}) { |(k, v), hash| hash[k] = v }
        RUBY
      end

      it 'registers an offense with a single line block and multiple keys' do
        expect_offense(<<~RUBY)
          enumerable.reduce({}) { |hash, (k, v)| hash.merge(k => v, foo => bar) }
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ #{message}
        RUBY

        # Not this cop's responsibility to decide how to format multiline blocks

        expect_correction(<<~RUBY)
          enumerable.each_with_object({}) { |(k, v), hash| hash[k] = v
          hash[foo] = bar }
        RUBY
      end
    end

    context 'with `Hash#merge!`' do
      it 'does not register an offense' do
        expect_no_offenses(<<~RUBY)
          enumerable.reduce({}) do |hash, (key, value)|
            hash.merge!(key => value)
          end
        RUBY
      end
    end
  end

  context 'when using `Enumerable#each_with_object`' do
    it 'does not register an offense' do
      expect_no_offenses(<<~RUBY)
        enumerable.each_with_object({}) do |hash, (key, value)|
          hash[key] = value
        end
      RUBY
    end
  end
end
