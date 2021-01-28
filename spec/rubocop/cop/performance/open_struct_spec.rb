# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Performance::OpenStruct, :config do
  it 'registers an offense for OpenStruct.new' do
    expect_offense(<<~RUBY)
      OpenStruct.new(key: "value")
                 ^^^ Consider using `Struct` over `OpenStruct` to optimize the performance.
    RUBY
  end

  it 'registers an offense for a fully qualified ::OpenStruct.new' do
    expect_offense(<<~RUBY)
      ::OpenStruct.new(key: "value")
                   ^^^ Consider using `Struct` over `OpenStruct` to optimize the performance.
    RUBY
  end

  it 'does not register offense for Struct' do
    expect_no_offenses(<<~RUBY)
      MyStruct = Struct.new(:key)
      MyStruct.new('value')
    RUBY
  end
end
