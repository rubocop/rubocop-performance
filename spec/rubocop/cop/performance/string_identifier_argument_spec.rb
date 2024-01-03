# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Performance::StringIdentifierArgument, :config do
  RuboCop::Cop::Performance::StringIdentifierArgument::RESTRICT_ON_SEND.each do |method|
    if method == RuboCop::Cop::Performance::StringIdentifierArgument::TWO_ARGUMENTS_METHOD
      it 'registers an offense when using string two arguments for `alias_method`' do
        expect_offense(<<~RUBY)
          alias_method 'new', 'original'
                       ^^^^^ Use `:new` instead of `'new'`.
                              ^^^^^^^^^^ Use `:original` instead of `'original'`.
        RUBY

        expect_correction(<<~RUBY)
          alias_method :new, :original
        RUBY
      end

      it 'does not register an offense when using symbol two arguments for `alias_method`' do
        expect_no_offenses(<<~RUBY)
          alias_method :new, :original
        RUBY
      end

      it 'does not register an offense when using symbol single argument for `alias_method`' do
        expect_no_offenses(<<~RUBY)
          alias_method :new
        RUBY
      end
    else
      it "registers an offense when using string argument for `#{method}` method" do
        expect_offense(<<~RUBY, method: method)
          #{method}('do_something')
          _{method} ^^^^^^^^^^^^^^ Use `:do_something` instead of `'do_something'`.
        RUBY

        expect_correction(<<~RUBY)
          #{method}(:do_something)
        RUBY
      end

      it "does not register an offense when using symbol argument for `#{method}` method" do
        expect_no_offenses(<<~RUBY)
          #{method}(:do_something)
        RUBY
      end

      if RuboCop::Cop::Performance::StringIdentifierArgument::INTERPOLATION_IGNORE_METHODS.include?(method)
        it 'does not register an offense when using string interpolation for `#{method}` method' do
          # NOTE: These methods don't support `::` when passing a symbol. const_get('A::B') is valid
          # but const_get(:'A::B') isn't. Since interpolated arguments may contain any content these
          # cases are not detected as an offense to prevent false positives.
          expect_no_offenses(<<~RUBY)
            #{method}("\#{module_name}class_name")
          RUBY
        end
      else
        it 'registers an offense when using interpolated string argument' do
          expect_offense(<<~RUBY, method: method)
            #{method}("do_something_\#{var}")
            _{method} ^^^^^^^^^^^^^^^^^^^^^ Use `:"do_something_\#{var}"` instead of `"do_something_\#{var}"`.
          RUBY

          expect_correction(<<~RUBY)
            #{method}(:"do_something_\#{var}")
          RUBY
        end
      end
    end
  end

  RuboCop::Cop::Performance::StringIdentifierArgument::MULTIPLE_ARGUMENTS_METHODS.each do |method|
    it "registers an offense when using string multiple arguments for `#{method}` method" do
      expect_offense(<<~RUBY, method: method)
        #{method} 'one', 'two', 'three'
        _{method} ^^^^^ Use `:one` instead of `'one'`.
        _{method}        ^^^^^ Use `:two` instead of `'two'`.
        _{method}               ^^^^^^^ Use `:three` instead of `'three'`.
      RUBY

      expect_correction(<<~RUBY)
        #{method} :one, :two, :three
      RUBY
    end

    it "does not register an offense when using symbol multiple arguments for `#{method}`" do
      expect_no_offenses(<<~RUBY)
        #{method} :one, :two, :three
      RUBY
    end
  end

  RuboCop::Cop::Performance::StringIdentifierArgument::COMMAND_METHODS.each do |method|
    it "does not register an offense when using string argument for `#{method}` method with receiver" do
      expect_no_offenses(<<~RUBY)
        obj.#{method}('do_something')
      RUBY
    end
  end

  it 'does not register an offense when no arguments' do
    expect_no_offenses(<<~RUBY)
      send
    RUBY
  end

  it 'does not register an offense when using integer argument' do
    expect_no_offenses(<<~RUBY)
      send(42)
    RUBY
  end

  it 'does not register an offense when using cbase class string argument' do
    expect_no_offenses(<<~RUBY)
      Object.const_defined?('::Foo')
    RUBY
  end

  it 'does not register an offense when using namespaced class string argument' do
    expect_no_offenses(<<~RUBY)
      Object.const_defined?('Foo::Bar')
    RUBY
  end

  it 'does not register an offense when using symbol argument for no identifier argument' do
    expect_no_offenses(<<~RUBY)
      foo('do_something')
    RUBY
  end

  # e.g. Trunip https://github.com/jnicklas/turnip#calling-steps-from-other-steps
  it 'does not register an offense when using string argument includes spaces' do
    expect_no_offenses(<<~RUBY)
      send(':foo is :bar', foo, bar)
    RUBY
  end

  # NOTE: `attr` method is not included in this list as it can cause false positives in Nokogiri API.
  # And `attr` may not be used because `Style/Attr` registers an offense.
  # https://github.com/rubocop/rubocop-performance/issues/278
  it 'does not register an offense when using string argument for `attr` method' do
    expect_no_offenses(<<~RUBY)
      attr('foo')
    RUBY
  end
end
