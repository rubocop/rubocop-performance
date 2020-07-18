# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Performance::Sum do
  subject(:cop) { described_class.new }

  %i[inject reduce].each do |method|
    it "registers an offense and corrects when using `array.#{method}(10, :+)`" do
      source = "array.#{method}(10, :+)"
      inspect_source(source)

      expect(cop.offenses.size).to eq(1)
      expect(cop.highlights).to eq(["#{method}(10, :+)"])

      new_source = autocorrect_source(source)
      expect(new_source).to eq('array.sum(10)')
    end

    it "registers an offense and corrects when using `array.#{method}(10) { |acc, elem| acc + elem }`" do
      source = "array.#{method}(10) { |acc, elem| acc + elem }"
      inspect_source(source)

      expect(cop.offenses.size).to eq(1)
      expect(cop.highlights).to eq(["#{method}(10) { |acc, elem| acc + elem }"])

      new_source = autocorrect_source(source)
      expect(new_source).to eq('array.sum(10)')
    end

    it "registers an offense and corrects when using `array.#{method}(10) { |acc, elem| elem + acc }`" do
      source = "array.#{method}(10) { |acc, elem| elem + acc }"
      inspect_source(source)

      expect(cop.offenses.size).to eq(1)
      expect(cop.highlights).to eq(["#{method}(10) { |acc, elem| elem + acc }"])

      new_source = autocorrect_source(source)
      expect(new_source).to eq('array.sum(10)')
    end

    it 'does not autocorrect when initial value is not provided' do
      source = "array.#{method}(:+)"
      inspect_source(source)

      expect(cop.offenses.size).to eq(1)
      expect(cop.highlights).to eq(["#{method}(:+)"])

      new_source = autocorrect_source(source)
      expect(new_source).to eq(source)
    end

    it 'does not register an offense when block does not implement summation' do
      source = "array.#{method} { |acc, elem| elem * 2 }"
      inspect_source(source)
      expect(cop.offenses.size).to eq(0)
    end

    it 'does not register an offense when using `sum`' do
      expect_no_offenses(<<~RUBY)
        array.sum
      RUBY
    end
  end
end
