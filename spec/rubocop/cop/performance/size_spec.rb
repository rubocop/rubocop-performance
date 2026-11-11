# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Performance::Size, :config do
  it 'does not register an offense when calling count as a stand alone method' do
    expect_no_offenses('count(items)')
  end

  it 'does not register an offense when calling count on an object other than an array or a hash' do
    expect_no_offenses('object.count(items)')
  end

  describe 'on array' do
    it 'registers an offense when calling count' do
      expect_offense(<<~RUBY)
        [1, 2, 3].count
                  ^^^^^ Use `size` instead of `count`.
      RUBY
    end

    it 'registers an offense when safe navigation calling count' do
      expect_offense(<<~RUBY)
        [1, 2, 3]&.count
                   ^^^^^ Use `size` instead of `count`.
      RUBY
    end

    it 'registers an offense when calling count on to_a' do
      expect_offense(<<~RUBY)
        (1..3).to_a.count
                    ^^^^^ Use `size` instead of `count`.
      RUBY
    end

    it 'registers an offense when safe navigation calling count on to_a' do
      expect_offense(<<~RUBY)
        (1..3)&.to_a&.count
                      ^^^^^ Use `size` instead of `count`.
      RUBY
    end

    it 'registers an offense when calling count on Array[]' do
      expect_offense(<<~RUBY)
        Array[*1..5].count
                     ^^^^^ Use `size` instead of `count`.
      RUBY
    end

    it 'registers an offense when calling count on Array()' do
      expect_offense(<<~RUBY)
        Array(1..5).count
                    ^^^^^ Use `size` instead of `count`.
      RUBY
    end

    it 'does not register an offense when calling size' do
      expect_no_offenses('[1, 2, 3].size')
    end

    it 'does not register an offense when calling another method' do
      expect_no_offenses('[1, 2, 3].each')
    end

    it 'does not register an offense when calling count with a block' do
      expect_no_offenses('[1, 2, 3].count { |e| e > 3 }')
    end

    it 'does not register an offense when calling count with a to_proc block' do
      expect_no_offenses('[1, 2, 3].count(&:nil?)')
    end

    it 'does not register an offense when calling count with an argument' do
      expect_no_offenses('[1, 2, 3].count(1)')
    end

    it 'corrects count to size' do
      new_source = autocorrect_source('[1, 2, 3].count')

      expect(new_source).to eq('[1, 2, 3].size')
    end

    it 'corrects count to size on to_a' do
      new_source = autocorrect_source('(1..3).to_a.count')

      expect(new_source).to eq('(1..3).to_a.size')
    end

    it 'corrects count to size on Array[]' do
      new_source = autocorrect_source('Array[*1..5].count')

      expect(new_source).to eq('Array[*1..5].size')
    end

    it 'corrects count to size on Array()' do
      new_source = autocorrect_source('Array(1..5).count')

      expect(new_source).to eq('Array(1..5).size')
    end
  end

  describe 'on hash' do
    it 'registers an offense when calling count' do
      expect_offense(<<~RUBY)
        {a: 1, b: 2, c: 3}.count
                           ^^^^^ Use `size` instead of `count`.
      RUBY
    end

    it 'registers an offense when calling count on to_h' do
      expect_offense(<<~RUBY)
        [[:foo, :bar], [1, 2]].to_h.count
                                    ^^^^^ Use `size` instead of `count`.
      RUBY
    end

    it 'registers an offense when safe navigation calling count on to_h' do
      expect_offense(<<~RUBY)
        [[:foo, :bar], [1, 2]]&.to_h&.count
                                      ^^^^^ Use `size` instead of `count`.
      RUBY
    end

    it 'registers an offense when calling count on Hash[]' do
      expect_offense(<<~RUBY)
        Hash[*('a'..'z')].count
                          ^^^^^ Use `size` instead of `count`.
      RUBY
    end

    it 'registers an offense when calling count on Hash()' do
      expect_offense(<<~RUBY)
        Hash(key: :value).count
                          ^^^^^ Use `size` instead of `count`.
      RUBY
    end

    it 'does not register an offense when calling size' do
      expect_no_offenses('{a: 1, b: 2, c: 3}.size')
    end

    it 'does not register an offense when calling another method' do
      expect_no_offenses('{a: 1, b: 2, c: 3}.each')
    end

    it 'does not register an offense when calling count with a block' do
      expect_no_offenses('{a: 1, b: 2, c: 3}.count { |e| e > 3 }')
    end

    it 'does not register an offense when calling count with a to_proc block' do
      expect_no_offenses('{a: 1, b: 2, c: 3}.count(&:nil?)')
    end

    it 'does not register an offense when calling count with an argument' do
      expect_no_offenses('{a: 1, b: 2, c: 3}.count(1)')
    end

    it 'corrects count to size' do
      new_source = autocorrect_source('{a: 1, b: 2, c: 3}.count')

      expect(new_source).to eq('{a: 1, b: 2, c: 3}.size')
    end

    it 'corrects count to size on to_h' do
      new_source = autocorrect_source('[[:foo, :bar], [1, 2]].to_h.count')

      expect(new_source).to eq('[[:foo, :bar], [1, 2]].to_h.size')
    end

    it 'corrects count to size on Hash[]' do
      new_source = autocorrect_source("Hash[*('a'..'z')].count")

      expect(new_source).to eq("Hash[*('a'..'z')].size")
    end

    it 'corrects count to size on Hash()' do
      new_source = autocorrect_source('Hash(key: :value).count')

      expect(new_source).to eq('Hash(key: :value).size')
    end
  end

  context 'when using numbered parameter', :ruby27 do
    it 'does not register an offense when calling count with a block' do
      expect_no_offenses(<<~RUBY)
        [1, 2, 3].count { _1 > 1 }
      RUBY
    end
  end

  context 'when using `it` parameter', :ruby34, unsupported_on: :parser do
    it 'does not register an offense when calling count with a block' do
      expect_no_offenses(<<~RUBY)
        [1, 2, 3].count { it > 1 }
      RUBY
    end
  end

  context 'when `count` is the body of a block' do
    context 'with a named block parameter' do
      it 'registers an offense and corrects when calling `to_a.count`' do
        expect_offense(<<~RUBY)
          items.map { |x| x.to_a.count }
                                 ^^^^^ Use `size` instead of `count`.
        RUBY

        expect_correction(<<~RUBY)
          items.map { |x| x.to_a.size }
        RUBY
      end

      it 'registers an offense and corrects when calling `count` on `Array()`' do
        expect_offense(<<~RUBY)
          groups.map { |x| Array(x).count }
                                    ^^^^^ Use `size` instead of `count`.
        RUBY

        expect_correction(<<~RUBY)
          groups.map { |x| Array(x).size }
        RUBY
      end
    end

    context 'with a numbered parameter', :ruby27 do
      it 'registers an offense and corrects when calling `to_a.count`' do
        expect_offense(<<~RUBY)
          items.map { _1.to_a.count }
                              ^^^^^ Use `size` instead of `count`.
        RUBY

        expect_correction(<<~RUBY)
          items.map { _1.to_a.size }
        RUBY
      end

      it 'registers an offense and corrects when calling `count` on `Array()`' do
        expect_offense(<<~RUBY)
          groups.map { Array(_1).count }
                                 ^^^^^ Use `size` instead of `count`.
        RUBY

        expect_correction(<<~RUBY)
          groups.map { Array(_1).size }
        RUBY
      end
    end

    context 'with the `it` parameter', :ruby34, unsupported_on: :parser do
      it 'registers an offense and corrects when calling `to_a.count`' do
        expect_offense(<<~RUBY)
          items.map { it.to_a.count }
                              ^^^^^ Use `size` instead of `count`.
        RUBY

        expect_correction(<<~RUBY)
          items.map { it.to_a.size }
        RUBY
      end

      it 'registers an offense and corrects when calling `count` on `Array()`' do
        expect_offense(<<~RUBY)
          groups.map { Array(it).count }
                                 ^^^^^ Use `size` instead of `count`.
        RUBY

        expect_correction(<<~RUBY)
          groups.map { Array(it).size }
        RUBY
      end
    end
  end

  context 'when `count` is given a block' do
    context 'with a named block parameter' do
      it 'does not register an offense' do
        expect_no_offenses(<<~RUBY)
          [1, 2, 3].count { |x| x > 1 }
        RUBY
      end
    end

    context 'with a numbered parameter', :ruby27 do
      it 'does not register an offense' do
        expect_no_offenses(<<~RUBY)
          [1, 2, 3].count { _1 > 1 }
        RUBY
      end
    end

    context 'with the `it` parameter', :ruby34, unsupported_on: :parser do
      it 'does not register an offense' do
        expect_no_offenses(<<~RUBY)
          [1, 2, 3].count { it > 1 }
        RUBY
      end
    end
  end
end
