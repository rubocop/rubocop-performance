# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Performance::ConstantRegexp do
  subject(:cop) { described_class.new }

  it 'registers an offense and corrects when regexp contains interpolated constant' do
    expect_offense(<<~RUBY)
      str.match?(/\A\#{CONST}/)
                 ^^^^^^^^^^^ Extract this regexp into a constant or append an `/o` option to its options.
    RUBY

    expect_correction(<<~RUBY)
      str.match?(/\A\#{CONST}/o)
    RUBY
  end

  it 'registers an offense and corrects when regexp contains multiple interpolated constants' do
    expect_offense(<<~RUBY)
      str.match?(/\A\#{CONST1}something\#{CONST2}\z/)
                 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Extract this regexp into a constant or append an `/o` option to its options.
    RUBY

    expect_correction(<<~RUBY)
      str.match?(/\A\#{CONST1}something\#{CONST2}\z/o)
    RUBY
  end

  it 'registers an offense and corrects when regexp contains `Regexp.escape` on constant' do
    expect_offense(<<~RUBY)
      str.match?(/\A\#{CONST1}something\#{Regexp.escape(CONST2)}\z/)
                 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Extract this regexp into a constant or append an `/o` option to its options.
    RUBY

    expect_correction(<<~RUBY)
      str.match?(/\A\#{CONST1}something\#{Regexp.escape(CONST2)}\z/o)
    RUBY
  end

  it 'does not register an offense when regexp does not contain interpolated constant' do
    expect_no_offenses(<<~RUBY)
      str.match?(/foo/)
    RUBY
  end

  it 'does not register an offense when regexp is within assignment to a constant' do
    expect_no_offenses(<<~RUBY)
      CONST = str.match?(/\#{ANOTHER_CONST}/)
    RUBY
  end

  it 'does not register an offense when regexp has `/o` option' do
    expect_no_offenses(<<~RUBY)
      str.match?(/\#{CONST}/o)
    RUBY
  end

  it 'does not register an offense when regexp contains interpolated constant and '\
     'and interpolated non constant' do
    expect_no_offenses(<<~RUBY)
      str.match?(/\#{CONST}\#{do_something(1)}/)
    RUBY
  end
end
