# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Performance::Squeeze, :config do
  it "registers an offense and corrects when using `#gsub(/a+/, 'a')`" do
    expect_offense(<<~RUBY)
      str.gsub(/a+/, 'a')
          ^^^^ Use `squeeze` instead of `gsub`.
    RUBY

    expect_correction(<<~RUBY)
      str.squeeze('a')
    RUBY
  end

  it "registers an offense and corrects when using `#gsub!(/a+/, 'a')`" do
    expect_offense(<<~RUBY)
      str.gsub!(/a+/, 'a')
          ^^^^^ Use `squeeze!` instead of `gsub!`.
    RUBY

    expect_correction(<<~RUBY)
      str.squeeze!('a')
    RUBY
  end

  it 'does not register an offense when using `#squeeze`' do
    expect_no_offenses(<<~RUBY)
      str.squeeze('a')
    RUBY
  end

  it 'does not register an offense when using `#squeeze!`' do
    expect_no_offenses(<<~RUBY)
      str.squeeze!('a')
    RUBY
  end

  it 'does not register an offense when replacement does not match pattern' do
    expect_no_offenses(<<~RUBY)
      str.gsub(/a+/, 'b')
    RUBY
  end
end
