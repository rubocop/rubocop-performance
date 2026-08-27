# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Performance::ReverseEach, :config do
  it 'registers an offense when each_with_index is called on reverse' do
    expect_offense(<<~RUBY)
      [1, 2, 3].reverse.each_with_index { |e, _i| puts e }
                ^^^^^^^^^^^^^^^^^^^^^^^ Use `reverse_each` instead of `reverse.each`.
    RUBY
  end

  it 'registers an offense when each_with_index is called on reverse with safe navigation operator' do
    expect_offense(<<~RUBY)
      array&.reverse.each_with_index { |e, _i| puts e }
             ^^^^^^^^^^^^^^^^^^^^^^^ Use `reverse_each` instead of `reverse.each`.
    RUBY
  end

  it 'registers an offense when each_with_index is called on reverse with safe navigation operator chain' do
    expect_offense(<<~RUBY)
      array&.reverse&.each_with_index { |e, _i| puts e }
             ^^^^^^^^^^^^^^^^^^^^^^^^ Use `reverse_each` instead of `reverse.each`.
    RUBY
  end

  it 'registers an offense when each_with_index is called on reverse on a variable' do
    expect_offense(<<~RUBY)
      arr = [1, 2, 3]
      arr.reverse.each_with_index { |e, _i| puts e }
          ^^^^^^^^^^^^^^^^^^^^^^^ Use `reverse_each` instead of `reverse.each`.
    RUBY
  end

  it 'registers an offense when each_with_index is called on reverse on a method call' do
    expect_offense(<<~RUBY)
      def arr
        [1, 2, 3]
      end

      arr.reverse.each_with_index { |e, _i| puts e }
          ^^^^^^^^^^^^^^^^^^^^^^^ Use `reverse_each` instead of `reverse.each`.
    RUBY
  end

  it 'registers an offense for a multi-line reverse.each_with_index' do
    expect_offense(<<~RUBY)
      def arr
        [1, 2, 3]
      end

      arr.
        reverse.
        ^^^^^^^^ Use `reverse_each` instead of `reverse.each`.
        each_with_index { |e, _i| puts e }
    RUBY
  end

  it 'does not register an offense when reverse is used without each' do
    expect_no_offenses('[1, 2, 3].reverse')
  end

  it 'does not register an offense when each_with_index is used without reverse' do
    expect_no_offenses('[1, 2, 3].each_with_index { |e, _i| puts e }')
  end

  context 'autocorrect' do
    it 'corrects reverse.each_with_index to reverse_each_with_index' do
      new_source = autocorrect_source('[1, 2].reverse.each_with_index { |e, _i| puts e }')

      expect(new_source).to eq('[1, 2].reverse_each.with_index { |e, _i| puts e }')
    end

    it 'corrects reverse.each_with_index to reverse_each_with_index on a variable' do
      new_source = autocorrect_source(<<~RUBY)
        arr = [1, 2]
        arr.reverse.each_with_index { |e, _i| puts e }
      RUBY

      expect(new_source).to eq(<<~RUBY)
        arr = [1, 2]
        arr.reverse_each.with_index { |e, _i| puts e }
      RUBY
    end

    it 'corrects reverse.each_with_index to reverse_each_with_index on a method call' do
      new_source = autocorrect_source(<<~RUBY)
        def arr
          [1, 2]
        end

        arr.reverse.each_with_index { |e, _i| puts e }
      RUBY

      expect(new_source).to eq(<<~RUBY)
        def arr
          [1, 2]
        end

        arr.reverse_each.with_index { |e, _i| puts e }
      RUBY
    end

    it 'registers and corrects when using multi-line `reverse.each_with_index` with trailing dot' do
      expect_offense(<<~RUBY)
        def arr
          [1, 2]
        end

        arr.
          reverse.
          ^^^^^^^^ Use `reverse_each` instead of `reverse.each`.
          each_with_index { |e, _i| puts e }
      RUBY

      expect_correction(<<~RUBY)
        def arr
          [1, 2]
        end

        arr.
          reverse_each.with_index { |e, _i| puts e }
      RUBY
    end

    it 'registers and corrects when using multi-line `reverse.each_with_index` with leading dot' do
      expect_offense(<<~RUBY)
        def arr
          [1, 2]
        end

        arr
          .reverse
           ^^^^^^^ Use `reverse_each` instead of `reverse.each`.
          .each_with_index { |e, _i| puts e }
      RUBY

      expect_correction(<<~RUBY)
        def arr
          [1, 2]
        end

        arr
          .reverse_each.with_index { |e, _i| puts e }
      RUBY
    end
  end

  it 'does not register an offense when each_with_index is called on reverse and assign the result to lvar' do
    expect_no_offenses(<<~RUBY)
      ret = [1, 2, 3].reverse.each_with_index { |e, _i| puts e }
    RUBY
  end

  it 'does not register an offense when each_with_index is called on reverse and assign the result to ivar' do
    expect_no_offenses(<<~RUBY)
      @ret = [1, 2, 3].reverse.each_with_index { |e, _i| puts e }
    RUBY
  end

  it 'does not register an offense when each_with_index is called on reverse and assign the result to cvar' do
    expect_no_offenses(<<~RUBY)
      @@ret = [1, 2, 3].reverse.each_with_index { |e, _i| puts e }
    RUBY
  end

  it 'does not register an offense when each_with_index is called on reverse and assign the result to gvar' do
    expect_no_offenses(<<~RUBY)
      $ret = [1, 2, 3].reverse.each_with_index { |e, _i| puts e }
    RUBY
  end

  it 'does not register an offense when each_with_index is called on reverse and assign the result to constant' do
    expect_no_offenses(<<~RUBY)
      RET = [1, 2, 3].reverse.each_with_index { |e, _i| puts e }
    RUBY
  end

  it 'does not register an offense when each_with_index is called on reverse and using the result to method chain' do
    expect_no_offenses(<<~RUBY)
      [1, 2, 3].reverse.each_with_index { |e, _i| puts e }.last
    RUBY
  end

  it 'does not register an offense when each_with_index is called on reverse and returning the result' do
    expect_no_offenses(<<~RUBY)
      return [1, 2, 3].reverse.each_with_index { |e, _i| puts e }
    RUBY
  end
end
