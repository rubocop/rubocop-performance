# frozen_string_literal: true

#   do_something if str.match(/regex/)
#   while regex.match('str')
#     do_something
#   end
#
#   @good
#   method(str.match(/regex/))
#   return regex.match('str')

RSpec.describe RuboCop::Cop::Performance::RedundantMatch, :config do
  it 'autocorrects .match in if condition' do
    new_source = autocorrect_source('something if str.match(/regex/)')
    expect(new_source).to eq 'something if str =~ /regex/'
  end

  it 'autocorrects .match in unless condition' do
    new_source = autocorrect_source('something unless str.match(/regex/)')
    expect(new_source).to eq 'something unless str =~ /regex/'
  end

  it 'autocorrects .match in while condition' do
    new_source = autocorrect_source(<<~RUBY)
      while str.match(/regex/)
        do_something
      end
    RUBY
    expect(new_source).to eq(<<~RUBY)
      while str =~ /regex/
        do_something
      end
    RUBY
  end

  it 'autocorrects .match in until condition' do
    new_source = autocorrect_source(<<~RUBY)
      until str.match(/regex/)
        do_something
      end
    RUBY
    expect(new_source).to eq(<<~RUBY)
      until str =~ /regex/
        do_something
      end
    RUBY
  end

  it 'autocorrects .match in method body (but not tail position)' do
    new_source = autocorrect_source(<<~RUBY)
      def method(str)
        str.match(/regex/)
        true
      end
    RUBY
    expect(new_source).to eq(<<~RUBY)
      def method(str)
        str =~ /regex/
        true
      end
    RUBY
  end

  it 'does not autocorrect if .match has a string agrgument' do
    new_source = autocorrect_source('something if str.match("string")')
    expect(new_source).to eq 'something if str.match("string")'
  end

  it 'does not register an error when return value of .match is passed to another method' do
    expect_no_offenses(<<~RUBY)
      def method(str)
       something(str.match(/regex/))
      end
    RUBY
  end

  it 'does not register an error when return value of .match is stored in an instance variable' do
    expect_no_offenses(<<~RUBY)
      def method(str)
       @var = str.match(/regex/)
       true
      end
    RUBY
  end

  it 'does not register an error when return value of .match is returned from surrounding method' do
    expect_no_offenses(<<~RUBY)
      def method(str)
       str.match(/regex/)
      end
    RUBY
  end

  it 'does not register an offense when match has a block' do
    expect_no_offenses(<<~RUBY)
      /regex/.match(str) do |m|
        something(m)
      end
    RUBY
  end

  it 'does not register an error when there is no receiver to the match call' do
    expect_no_offenses('match("bar")')
  end

  it 'formats error message correctly for something if str.match(/regex/)' do
    expect_offense(<<~RUBY)
      something if str.match(/regex/)
                   ^^^^^^^^^^^^^^^^^^ Use `=~` in places where the `MatchData` returned by `#match` will not be used.
    RUBY
  end

  it 'registers an offense and corrects when receiver is a Regexp literal' do
    expect_offense(<<~RUBY)
      something if /regex/.match(str)
                   ^^^^^^^^^^^^^^^^^^ Use `=~` in places where the `MatchData` returned by `#match` will not be used.
    RUBY

    expect_correction(<<~RUBY)
      something if /regex/ =~ str
    RUBY
  end

  shared_examples 'require parentheses' do |arg|
    it "registers an offense and corrects when argument is `#{arg}`" do
      expect_offense(<<~RUBY, arg: arg)
        something if /regex/.match(%{arg})
                     ^^^^^^^^^^^^^^^{arg}^ Use `=~` in places where the `MatchData` returned by `#match` will not be used.
      RUBY

      expect_correction(<<~RUBY)
        something if /regex/ =~ (#{arg})
      RUBY
    end
  end

  it_behaves_like 'require parentheses', 'a ? b : c'
  it_behaves_like 'require parentheses', 'a && b'
  it_behaves_like 'require parentheses', 'a || b'
  it_behaves_like 'require parentheses', 'a..b'
  it_behaves_like 'require parentheses', 'method a'
  it_behaves_like 'require parentheses', 'yield a'
  it_behaves_like 'require parentheses', 'super a'
  it_behaves_like 'require parentheses', 'a == b'

  shared_examples 'require no parentheses' do |arg|
    it "registers an offense and corrects when argument is `#{arg}`" do
      expect_offense(<<~RUBY, arg: arg)
        something if /regex/.match(%{arg})
                     ^^^^^^^^^^^^^^^{arg}^ Use `=~` in places where the `MatchData` returned by `#match` will not be used.
      RUBY

      expect_correction(<<~RUBY)
        something if /regex/ =~ #{arg}
      RUBY
    end
  end

  it_behaves_like 'require no parentheses', 'if a then b else c end'
  it_behaves_like 'require no parentheses', 'method(a)'
  it_behaves_like 'require no parentheses', 'method'
  it_behaves_like 'require no parentheses', 'yield'
  it_behaves_like 'require no parentheses', 'super'
  it_behaves_like 'require no parentheses', 'a.==(b)'

  %w[| ^ & + - * / % ** > >= < <= << >>].each do |op|
    it_behaves_like 'require no parentheses', "a #{op} b"
  end
end
