# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Performance::CollectionLiteralInLoop, :config do
  let(:cop_config) do
    { 'MinSize' => 1 }
  end

  context 'when inside `while` loop' do
    it 'registers an offense when using Array literal' do
      expect_offense(<<~RUBY)
        while true
          [1, 2, 3].include?(e)
          ^^^^^^^^^ Avoid immutable Array literals in loops. It is better to extract it into a local variable or a constant.
        end
      RUBY
    end

    it 'registers an offense when using Hash literal' do
      expect_offense(<<~RUBY)
        while i < 100
          { foo: :bar }.key?(:foo)
          ^^^^^^^^^^^^^ Avoid immutable Hash literals in loops. It is better to extract it into a local variable or a constant.
        end
      RUBY
    end
  end

  context 'when inside `until` loop' do
    it 'registers an offense when using Array literal' do
      expect_offense(<<~RUBY)
        until i < 100
          [1, 2, 3].include?(e)
          ^^^^^^^^^ Avoid immutable Array literals in loops. It is better to extract it into a local variable or a constant.
        end
      RUBY
    end

    it 'registers an offense when using Hash literal' do
      expect_offense(<<~RUBY)
        until i < 100
          { foo: :bar }.key?(:foo)
          ^^^^^^^^^^^^^ Avoid immutable Hash literals in loops. It is better to extract it into a local variable or a constant.
        end
      RUBY
    end
  end

  context 'when inside `for` loop' do
    it 'registers an offense when using Array literal' do
      expect_offense(<<~RUBY)
        for i in 1..100
          [1, 2, 3].include?(e)
          ^^^^^^^^^ Avoid immutable Array literals in loops. It is better to extract it into a local variable or a constant.
        end
      RUBY
    end

    it 'registers an offense when using Hash literal' do
      expect_offense(<<~RUBY)
        for i in 1..100
          { foo: :bar }.key?(:foo)
          ^^^^^^^^^^^^^ Avoid immutable Hash literals in loops. It is better to extract it into a local variable or a constant.
        end
      RUBY
    end
  end

  context 'when inside `while modifier` loop' do
    it 'registers an offense when using Array literal' do
      expect_offense(<<~RUBY)
        begin
          [1, 2, 3].include?(e)
          ^^^^^^^^^ Avoid immutable Array literals in loops. It is better to extract it into a local variable or a constant.
        end while i < 100
      RUBY
    end

    it 'registers an offense when using Hash literal' do
      expect_offense(<<~RUBY)
        begin
          { foo: :bar }.key?(:foo)
          ^^^^^^^^^^^^^ Avoid immutable Hash literals in loops. It is better to extract it into a local variable or a constant.
        end while i < 100
      RUBY
    end
  end

  context 'when inside `until modifier` loop' do
    it 'registers an offense when using Array literal' do
      expect_offense(<<~RUBY)
        begin
          [1, 2, 3].include?(e)
          ^^^^^^^^^ Avoid immutable Array literals in loops. It is better to extract it into a local variable or a constant.
        end until i < 100
      RUBY
    end

    it 'registers an offense when using Hash literal' do
      expect_offense(<<~RUBY)
        begin
          { foo: :bar }.key?(:foo)
          ^^^^^^^^^^^^^ Avoid immutable Hash literals in loops. It is better to extract it into a local variable or a constant.
        end until i < 100
      RUBY
    end
  end

  context 'when inside `Kernel#loop` loop' do
    it 'registers an offense when using Array literal' do
      expect_offense(<<~RUBY)
        loop do
          [1, 2, 3].include?(e)
          ^^^^^^^^^ Avoid immutable Array literals in loops. It is better to extract it into a local variable or a constant.
        end
      RUBY
    end

    it 'registers an offense when using Hash literal' do
      expect_offense(<<~RUBY)
        loop do
          { foo: :bar }.key?(:foo)
          ^^^^^^^^^^^^^ Avoid immutable Hash literals in loops. It is better to extract it into a local variable or a constant.
        end
      RUBY
    end
  end

  context 'when inside one of `Enumerable` loop-like methods' do
    it 'registers an offense when using Array literal' do
      expect_offense(<<~RUBY)
        array.all? do |e|
          [1, 2, 3].include?(e)
          ^^^^^^^^^ Avoid immutable Array literals in loops. It is better to extract it into a local variable or a constant.
        end
      RUBY
    end

    it 'registers an offense when using Hash literal' do
      expect_offense(<<~RUBY)
        array.all? do |e|
          { foo: :bar }.key?(:foo)
          ^^^^^^^^^^^^^ Avoid immutable Hash literals in loops. It is better to extract it into a local variable or a constant.
        end
      RUBY
    end

    it 'registers an offense when the method is called with no receiver' do
      expect_offense(<<~RUBY)
        all? do |e|
          [1, 2, 3].include?(e)
          ^^^^^^^^^ Avoid immutable Array literals in loops. It is better to extract it into a local variable or a constant.
        end
      RUBY
    end
  end

  context 'when not inside loop' do
    it 'does not register an offense when using Array literal' do
      expect_no_offenses(<<~RUBY)
        [1, 2, 3].include?(e)
      RUBY
    end

    it 'does not register an offense when using Hash literal' do
      expect_no_offenses(<<~RUBY)
        { foo: :bar }.key?(:foo)
      RUBY
    end
  end

  context 'when literal contains element of non basic type' do
    it 'does not register an offense when using Array literal' do
      expect_no_offenses(<<~RUBY)
        [1, 2, variable].include?(e)
      RUBY
    end

    it 'does not register an offense when using Hash literal' do
      expect_no_offenses(<<~RUBY)
        { foo: { bar: variable } }.key?(:foo)
      RUBY
    end
  end

  context 'when is an argument for `Enumerable` loop-like method' do
    it 'does not register an offense when using Array literal' do
      expect_no_offenses(<<~RUBY)
        [[1, 2, 3] | [2, 3, 4]].each { |e| puts e }
      RUBY
    end

    it 'does not register an offense when using Hash literal' do
      expect_no_offenses(<<~RUBY)
        ({ foo: :bar }.merge(baz: :quux)).each { |k, v| puts k + v }
      RUBY
    end
  end

  context 'when destructive method is called' do
    it 'does not register an offense when using Array literal' do
      expect_no_offenses(<<~RUBY)
        loop do
          [1, nil, 3].compact!
        end
      RUBY
    end

    it 'does not register an offense when using Hash literal' do
      expect_no_offenses(<<~RUBY)
        loop do
          { foo: :bar, baz: nil }.select! { |_k, v| !v.nil? }
        end
      RUBY
    end
  end

  context 'when none method is called' do
    it 'does not register an offense when using Array literal' do
      expect_no_offenses(<<~RUBY)
        loop do
          array = [1, nil, 3]
        end
      RUBY
    end

    it 'does not register an offense when using Hash literal' do
      expect_no_offenses(<<~RUBY)
        loop do
          hash = { foo: :bar, baz: nil }
        end
      RUBY
    end
  end

  it 'does not register an offense when there are no literals in a loop' do
    expect_no_offenses(<<~RUBY)
      while x < 100
        puts x
      end
    RUBY
  end

  it 'does not register an offense when nondestructive method is called on nonliteral' do
    expect_no_offenses(<<~RUBY)
      loop do
        array.all? { |x| x > 100 }
      end
    RUBY
  end

  context 'with MinSize of 2' do
    let(:cop_config) do
      { 'MinSize' => 2 }
    end

    it 'does not register an offense when using Array literal' do
      expect_no_offenses(<<~RUBY)
        while true
          [1].include?(e)
        end
      RUBY
    end

    it 'does not register an offense when using Hash literal' do
      expect_no_offenses(<<~RUBY)
        while i < 100
          { foo: :bar }.key?(:foo)
        end
      RUBY
    end
  end

  context 'when Ruby >= 3.4', :ruby34 do
    it 'registers an offense for `include?` on a Hash literal' do
      expect_offense(<<~RUBY)
        each do
          { foo: :bar }.include?(:foo)
          ^^^^^^^^^^^^^ Avoid immutable Hash literals in loops. It is better to extract it into a local variable or a constant.
        end
      RUBY
    end

    it 'registers an offense for other array methods' do
      expect_offense(<<~RUBY)
        each do
          [1, 2, 3].index(foo)
          ^^^^^^^^^ Avoid immutable Array literals in loops. It is better to extract it into a local variable or a constant.
        end
      RUBY
    end

    context 'when using an Array literal and calling `include?`' do
      [
        '"string"',
        'self',
        'local_variable',
        'method_call',
        '@instance_variable'
      ].each do |argument|
        it "registers no offense when the argument is #{argument}" do
          expect_no_offenses(<<~RUBY)
            #{'local_variable = 123' if argument == 'local_variable'}
            array.all? do |e|
              [1, 2, 3].include?(#{argument})
            end
          RUBY
        end

        it "registers no offense when the argument is #{argument} with method chain" do
          expect_no_offenses(<<~RUBY)
            #{'local_variable = 123' if argument == 'local_variable'}
            array.all? do |e|
              [1, 2, 3].include?(#{argument}.call)
            end
          RUBY
        end

        it "registers no offense when the argument is #{argument} with double method chain" do
          expect_no_offenses(<<~RUBY)
            #{'local_variable = 123' if argument == 'local_variable'}
            array.all? do |e|
              [1, 2, 3].include?(#{argument}.call.call)
            end
          RUBY
        end

        it "registers an offense when the argument is #{argument} with method chain and arguments" do
          expect_offense(<<~RUBY)
            #{'local_variable = 123' if argument == 'local_variable'}
            array.all? do |e|
              [1, 2, 3].include?(#{argument}.call(true))
              ^^^^^^^^^ Avoid immutable Array literals in loops. It is better to extract it into a local variable or a constant.
            end
          RUBY
        end
      end
    end
  end
end
