# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Performance::ArrayPushSingle, :config do
  it 'registers an offense and corrects when using `push` with a single element' do
    expect_offense(<<~RUBY)
      array.push(element)
      ^^^^^^^^^^^^^^^^^^^ Use `<<` instead of `push`.
    RUBY

    expect_correction(<<~RUBY)
      array << element
    RUBY
  end

  it 'registers an offense and corrects when using `push` with a single element and safe navigation operator' do
    expect_offense(<<~RUBY)
      array&.push(element)
      ^^^^^^^^^^^^^^^^^^^^ Use `<<` instead of `push`.
    RUBY

    # gross. TODO: make a configuration option?
    expect_correction(<<~RUBY)
      array&.<< element
    RUBY
  end

  it 'does not register an offense when using `push` with multiple elements' do
    expect_no_offenses(<<~RUBY)
      array.push(1, 2, 3)
    RUBY
  end

  it 'does not register an offense when using `push` with splatted elements' do
    expect_no_offenses(<<~RUBY)
      array.push(*elements)
    RUBY
  end

  # rubocop:disable Performance/ArrayPushSingle
  describe 'replacing `push` with `<<`' do
    subject(:array) { [1, 2, 3] }

    it 'returns the same result' do
      expect([1, 2, 3].push(4)).to eq([1, 2, 3] << 4)
    end

    it 'has the same side-effect' do
      a = [1, 2, 3]
      a << 4

      b = [1, 2, 3]
      b << 4

      expect(a).to eq(b)
    end
  end
  # rubocop:enable Performance/ArrayPushSingle
end
