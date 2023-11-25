# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Performance::ReverseEach, :config do
  it 'registers an offense when each is called on reverse' do
    expect_offense(<<~RUBY)
      [1, 2, 3].reverse.each { |e| puts e }
                ^^^^^^^^^^^^ Use `reverse_each` instead of `reverse.each`.
    RUBY
  end

  it 'registers an offense when each is called on reverse with safe navigation operator' do
    expect_offense(<<~RUBY)
      array&.reverse.each { |e| puts e }
             ^^^^^^^^^^^^ Use `reverse_each` instead of `reverse.each`.
    RUBY
  end

  it 'registers an offense when each is called on reverse with safe navigation operator chain' do
    expect_offense(<<~RUBY)
      array&.reverse&.each { |e| puts e }
             ^^^^^^^^^^^^^ Use `reverse_each` instead of `reverse.each`.
    RUBY
  end

  it 'registers an offense when each is called on reverse on a variable' do
    expect_offense(<<~RUBY)
      arr = [1, 2, 3]
      arr.reverse.each { |e| puts e }
          ^^^^^^^^^^^^ Use `reverse_each` instead of `reverse.each`.
    RUBY
  end

  it 'registers an offense when each is called on reverse on a method call' do
    expect_offense(<<~RUBY)
      def arr
        [1, 2, 3]
      end

      arr.reverse.each { |e| puts e }
          ^^^^^^^^^^^^ Use `reverse_each` instead of `reverse.each`.
    RUBY
  end

  it 'registers an offense for a multi-line reverse.each' do
    expect_offense(<<~RUBY)
      def arr
        [1, 2, 3]
      end

      arr.
        reverse.
        ^^^^^^^^ Use `reverse_each` instead of `reverse.each`.
        each { |e| puts e }
    RUBY
  end

  it 'does not register an offense when reverse is used without each' do
    expect_no_offenses('[1, 2, 3].reverse')
  end

  it 'does not register an offense when each is used without reverse' do
    expect_no_offenses('[1, 2, 3].each { |e| puts e }')
  end

  context 'autocorrect' do
    it 'corrects reverse.each to reverse_each' do
      new_source = autocorrect_source('[1, 2].reverse.each { |e| puts e }')

      expect(new_source).to eq('[1, 2].reverse_each { |e| puts e }')
    end

    it 'corrects reverse.each to reverse_each on a variable' do
      new_source = autocorrect_source(<<~RUBY)
        arr = [1, 2]
        arr.reverse.each { |e| puts e }
      RUBY

      expect(new_source).to eq(<<~RUBY)
        arr = [1, 2]
        arr.reverse_each { |e| puts e }
      RUBY
    end

    it 'corrects reverse.each to reverse_each on a method call' do
      new_source = autocorrect_source(<<~RUBY)
        def arr
          [1, 2]
        end

        arr.reverse.each { |e| puts e }
      RUBY

      expect(new_source).to eq(<<~RUBY)
        def arr
          [1, 2]
        end

        arr.reverse_each { |e| puts e }
      RUBY
    end

    it 'registers and corrects when using multi-line `reverse.each` with trailing dot' do
      expect_offense(<<~RUBY)
        def arr
          [1, 2]
        end

        arr.
          reverse.
          ^^^^^^^^ Use `reverse_each` instead of `reverse.each`.
          each { |e| puts e }
      RUBY

      expect_correction(<<~RUBY)
        def arr
          [1, 2]
        end

        arr.
          reverse_each { |e| puts e }
      RUBY
    end

    it 'registers and corrects when using multi-line `reverse.each` with leading dot' do
      expect_offense(<<~RUBY)
        def arr
          [1, 2]
        end

        arr
          .reverse
           ^^^^^^^ Use `reverse_each` instead of `reverse.each`.
          .each { |e| puts e }
      RUBY

      expect_correction(<<~RUBY)
        def arr
          [1, 2]
        end

        arr
          .reverse_each { |e| puts e }
      RUBY
    end
  end

  it 'does not register an offense when each is called on reverse and assign the result to lvar' do
    expect_no_offenses(<<~RUBY)
      ret = [1, 2, 3].reverse.each { |e| puts e }
    RUBY
  end

  it 'does not register an offense when each is called on reverse and assign the result to ivar' do
    expect_no_offenses(<<~RUBY)
      @ret = [1, 2, 3].reverse.each { |e| puts e }
    RUBY
  end

  it 'does not register an offense when each is called on reverse and assign the result to cvar' do
    expect_no_offenses(<<~RUBY)
      @@ret = [1, 2, 3].reverse.each { |e| puts e }
    RUBY
  end

  it 'does not register an offense when each is called on reverse and assign the result to gvar' do
    expect_no_offenses(<<~RUBY)
      $ret = [1, 2, 3].reverse.each { |e| puts e }
    RUBY
  end

  it 'does not register an offense when each is called on reverse and assign the result to constant' do
    expect_no_offenses(<<~RUBY)
      RET = [1, 2, 3].reverse.each { |e| puts e }
    RUBY
  end

  it 'does not register an offense when each is called on reverse and using the result to method chain' do
    expect_no_offenses(<<~RUBY)
      [1, 2, 3].reverse.each { |e| puts e }.last
    RUBY
  end

  it 'does not register an offense when each is called on reverse and returning the result' do
    expect_no_offenses(<<~RUBY)
      return [1, 2, 3].reverse.each { |e| puts e }
    RUBY
  end
end
