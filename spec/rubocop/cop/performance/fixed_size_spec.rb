# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Performance::FixedSize, :config do
  let(:message) do
    'Do not compute the size of statically sized objects.'
  end

  shared_examples 'common functionality' do |method|
    context 'strings' do
      it "registers an offense when calling #{method} on a single quoted string" do
        expect_offense(<<~RUBY, method: method)
          'a'.#{method}
          ^^^^^{method} Do not compute the size of statically sized objects.
        RUBY
      end

      it "registers an offense when calling #{method} on a double quoted string" do
        expect_offense(<<~RUBY, method: method)
          "a".#{method}
          ^^^^^{method} Do not compute the size of statically sized objects.
        RUBY
      end

      it "registers an offense when calling #{method} on a %q string" do
        expect_offense(<<~RUBY, method: method)
          %q(a).#{method}
          ^^^^^^^{method} Do not compute the size of statically sized objects.
        RUBY
      end

      it "registers an offense when calling #{method} on a %Q string" do
        expect_offense(<<~RUBY, method: method)
          %Q(a).#{method}
          ^^^^^^^{method} Do not compute the size of statically sized objects.
        RUBY
      end

      it "registers an offense when calling #{method} on a % string" do
        expect_offense(<<~RUBY, method: method)
          %(a).#{method}
          ^^^^^^{method} Do not compute the size of statically sized objects.
        RUBY
      end

      it "accepts calling #{method} on a double quoted string that contains interpolation" do
        expect_no_offenses("\"\#{foo}\".#{method}")
      end

      it "accepts calling #{method} on a %Q string that contains interpolation" do
        expect_no_offenses("\%Q(\#{foo}).#{method}")
      end

      it "accepts calling #{method} on a % string that contains interpolation" do
        expect_no_offenses("\%(\#{foo}).#{method}")
      end

      it "accepts calling #{method} on a single quoted string that is assigned to a constant" do
        expect_no_offenses("CONST = 'a'.#{method}")
      end

      it "accepts calling #{method} on a double quoted string that is assigned to a constant" do
        expect_no_offenses("CONST = \"a\".#{method}")
      end

      it "accepts calling #{method} on a %q string that is assigned to a constant" do
        expect_no_offenses("CONST = %q(a).#{method}")
      end

      it "accepts calling #{method} on a %q string that is assigned to " \
         'a constant along with some arithmetic operations' do
        expect_no_offenses("CONST = %q(a).#{method} + 1 * 20")
      end

      it "accepts calling #{method} on a variable " do
        expect_no_offenses(<<~RUBY)
          foo = "abc"
          foo.#{method}
        RUBY
      end
    end

    context 'symbols' do
      it "registers an offense when calling #{method} on a symbol" do
        expect_offense(<<~RUBY, method: method)
          :foo.#{method}
          ^^^^^^{method} Do not compute the size of statically sized objects.
        RUBY
      end

      it "registers an offense when calling #{method} on a quoted symbol" do
        expect_offense(<<~RUBY, method: method)
          :'foo-bar'.#{method}
          ^^^^^^^^^^^^{method} Do not compute the size of statically sized objects.
        RUBY
      end

      it "accepts calling #{method} on an interpolated quoted symbol" do
        expect_no_offenses(":\"foo-\#{bar}\".#{method}")
      end

      it "registers an offense when calling #{method} on %s" do
        expect_offense(<<~RUBY, method: method)
          %s(foo-bar).#{method}
          ^^^^^^^^^^^^^{method} Do not compute the size of statically sized objects.
        RUBY
      end

      it "accepts calling #{method} on a symbol that is assigned to a constant" do
        expect_no_offenses("CONST = :foo.#{method}")
      end
    end

    context 'arrays' do
      it "registers an offense when calling #{method} on an array using []" do
        expect_offense(<<~RUBY, method: method)
          [1, 2, foo].#{method}
          ^^^^^^^^^^^^^{method} Do not compute the size of statically sized objects.
        RUBY
      end

      it "registers an offense when calling #{method} on an array using %w" do
        expect_offense(<<~RUBY, method: method)
          %w(1, 2, foo).#{method}
          ^^^^^^^^^^^^^^^{method} Do not compute the size of statically sized objects.
        RUBY
      end

      it "registers an offense when calling #{method} on an array using %W" do
        expect_offense(<<~RUBY, method: method)
          %W(1, 2, foo).#{method}
          ^^^^^^^^^^^^^^^{method} Do not compute the size of statically sized objects.
        RUBY
      end

      it "accepts calling #{method} on an array using [] that contains a splat" do
        expect_no_offenses("[1, 2, *foo].#{method}")
      end

      it "accepts calling #{method} on array that is set to a variable" do
        expect_no_offenses(<<~RUBY)
          foo = [1, 2, 3]
          foo.#{method}
        RUBY
      end

      it "accepts calling #{method} on an array that is assigned to a constant" do
        expect_no_offenses("CONST = [1, 2, 3].#{method}")
      end
    end

    context 'hashes' do
      it "registers an offense when calling #{method} on a hash using {}" do
        expect_offense(<<~RUBY, method: method)
          {a: 1, b: 2}.#{method}
          ^^^^^^^^^^^^^^{method} Do not compute the size of statically sized objects.
        RUBY
      end

      it "accepts calling #{method} on a hash set to a variable" do
        expect_no_offenses(<<~RUBY)
          foo = {a: 1, b: 2}
          foo.#{method}
        RUBY
      end

      it "accepts calling #{method} on a hash that contains a double splat" do
        expect_no_offenses("{a: 1, **foo}.#{method}")
      end

      it "accepts calling #{method} on an hash that is assigned " \
         'to a constant' do
        expect_no_offenses("CONST = {a: 1, b: 2}.#{method}")
      end
    end
  end

  it_behaves_like 'common functionality', 'size'
  it_behaves_like 'common functionality', 'length'
  it_behaves_like 'common functionality', 'count'

  shared_examples 'count with arguments' do |variable|
    it 'accepts calling count with a variable' do
      expect_no_offenses("#{variable}.count(bar)")
    end

    it 'accepts calling count with an instance variable' do
      expect_no_offenses("#{variable}.count(@bar)")
    end

    it 'registers an offense when calling count with a string' do
      expect_offense(<<~RUBY, variable: variable)
        #{variable}.count('o')
        ^{variable}^^^^^^^^^^^ Do not compute the size of statically sized objects.
      RUBY
    end

    it 'accepts calling count with a block' do
      expect_no_offenses("#{variable}.count { |v| v == 'a' }")
    end

    it 'accepts calling count with a symbol proc' do
      expect_no_offenses("#{variable}.count(&:any?) ")
    end
  end

  it_behaves_like 'count with arguments', '"foo"'
  it_behaves_like 'count with arguments', '[1, 2, 3]'
  it_behaves_like 'count with arguments', '{a: 1, b: 2}'
end
