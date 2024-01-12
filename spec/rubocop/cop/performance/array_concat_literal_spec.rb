# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Performance::ArrayConcatLiteral, :config do
  it 'registers an offense and corrects when using `concat` with array literal' do
    expect_offense(<<~RUBY)
      array.concat([1, 2, 3])
      ^^^^^^^^^^^^^^^^^^^^^^^ Use `push` instead of concatinating a literal.
    RUBY

    expect_correction(<<~RUBY)
      array.push(1, 2, 3)
    RUBY
  end

  it 'registers an offense and corrects when using `concat` with array literal and safe navigation operator' do
    expect_offense(<<~RUBY)
      array&.concat([1, 2, 3])
      ^^^^^^^^^^^^^^^^^^^^^^^^ Use `push` instead of concatinating a literal.
    RUBY

    expect_correction(<<~RUBY)
      array&.push(1, 2, 3)
    RUBY
  end

  describe 'replacing `concat` with `push`' do
    it 'returns the same result' do
      expect([1, 2, 3].concat(4, 5, 6)).to eq([1, 2, 3].push(4, 5, 6))
    end

    it 'has the same side-effect' do
      expected = [1, 2, 3]
      expected.push(4, 5, 6)

      actual = [1, 2, 3]
      actual.push(4, 5, 6)

      expect(actual).to eq(expected)
    end
  end
end
