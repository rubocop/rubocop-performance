# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Performance::Caller do
  subject(:cop) { described_class.new }

  it 'accepts `caller` without argument and method chain' do
    expect_no_offenses('caller')
  end

  it 'accepts `caller` with arguments' do
    expect_no_offenses('caller(1, 1).first')
  end

  it 'accepts `caller_locations` without argument and method chain' do
    expect_no_offenses('caller_locations')
  end

  it 'registers an offense when :first is called on caller' do
    expect(caller.first).to eq(caller(1..1).first)
    expect_offense(<<-RUBY.strip_indent)
      caller.first
      ^^^^^^^^^^^^ Use `caller(1..1).first` instead of `caller.first`.
    RUBY
  end

  it 'registers an offense when :first is called on caller with 1' do
    expect(caller(1).first).to eq(caller(1..1).first)
    expect_offense(<<-RUBY.strip_indent)
      caller(1).first
      ^^^^^^^^^^^^^^^ Use `caller(1..1).first` instead of `caller.first`.
    RUBY
  end

  it 'registers an offense when :first is called on caller with 2' do
    expect(caller(2).first).to eq(caller(2..2).first)
    expect_offense(<<-RUBY.strip_indent)
      caller(2).first
      ^^^^^^^^^^^^^^^ Use `caller(2..2).first` instead of `caller.first`.
    RUBY
  end

  it 'registers an offense when :[] is called on caller' do
    expect(caller[1]).to eq(caller(2..2).first)
    expect_offense(<<-RUBY.strip_indent)
      caller[1]
      ^^^^^^^^^ Use `caller(2..2).first` instead of `caller[1]`.
    RUBY
  end

  it 'registers an offense when :[] is called on caller with 1' do
    expect(caller(1)[1]).to eq(caller(2..2).first)
    expect_offense(<<-RUBY.strip_indent)
      caller(1)[1]
      ^^^^^^^^^^^^ Use `caller(2..2).first` instead of `caller[1]`.
    RUBY
  end

  it 'registers an offense when :[] is called on caller with 2' do
    expect(caller(2)[1]).to eq(caller(3..3).first)
    expect_offense(<<-RUBY.strip_indent)
      caller(2)[1]
      ^^^^^^^^^^^^ Use `caller(3..3).first` instead of `caller[1]`.
    RUBY
  end

  it 'registers an offense when :first is called on caller_locations also' do
    expect(caller_locations.first.to_s).to eq(caller_locations(1..1).first.to_s)
    expect_offense(<<-RUBY.strip_indent)
      caller_locations.first
      ^^^^^^^^^^^^^^^^^^^^^^ Use `caller_locations(1..1).first` instead of `caller_locations.first`.
    RUBY
  end

  it 'registers an offense when :[] is called on caller_locations also' do
    expect(caller_locations[1].to_s).to eq(caller_locations(2..2).first.to_s)
    expect_offense(<<-RUBY.strip_indent)
      caller_locations[1]
      ^^^^^^^^^^^^^^^^^^^ Use `caller_locations(2..2).first` instead of `caller_locations[1]`.
    RUBY
  end
end
