# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Performance::IoReadlines do
  subject(:cop) { described_class.new }

  it 'registers an offense when using `File.readlines` followed by Enumerable method' do
    expect_offense(<<~RUBY)
      File.readlines('testfile').map { |l| l.size }
           ^^^^^^^^^^^^^^^^^^^^^^^^^ Use `each_line.map` instead of `readlines.map`.
    RUBY
  end

  it 'registers an offense when using `IO.readlines` followed by Enumerable method' do
    expect_offense(<<~RUBY)
      IO.readlines('testfile').map { |l| l.size }
         ^^^^^^^^^^^^^^^^^^^^^^^^^ Use `each_line.map` instead of `readlines.map`.
    RUBY
  end

  it 'registers an offense when using `IO.readlines` followed by `#each` method' do
    # NOTE: `each_line` in message, not `each_line.each`
    expect_offense(<<~RUBY)
      IO.readlines('testfile').each { |l| puts l }
         ^^^^^^^^^^^^^^^^^^^^^^^^^^ Use `each_line` instead of `readlines.each`.
    RUBY
  end

  it 'does not register an offense when using `.readlines` and not followed by Enumerable method' do
    expect_no_offenses(<<~RUBY)
      File.readlines('testfile').not_enumerable_method
    RUBY
  end

  it 'registers an offense and corrects when using `#readlines` on an instance followed by Enumerable method' do
    expect_offense(<<~RUBY)
      file.readlines(10).map { |l| l.size }
           ^^^^^^^^^^^^^^^^^ Use `each_line.map` instead of `readlines.map`.
    RUBY

    expect_correction(<<~RUBY)
      file.each_line(10).map { |l| l.size }
    RUBY
  end

  it 'registers an offense and corrects when using `#readlines` on an instance followed by `#each` method' do
    # NOTE: `each_line` in message, not `each_line.each`
    expect_offense(<<~RUBY)
      file.readlines(10).each { |l| puts l }
           ^^^^^^^^^^^^^^^^^^ Use `each_line` instead of `readlines.each`.
    RUBY

    expect_correction(<<~RUBY)
      file.each_line(10) { |l| puts l }
    RUBY
  end

  it 'does not register an offense when using `#readlines` on an instance and not followed by Enumerable method' do
    expect_no_offenses(<<~RUBY)
      file.readlines.not_enumerable_method
    RUBY
  end
end
