# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Performance::RangeInclude, :config do
  %i[include? member?].each do |method|
    it "autocorrects (a..b).#{method} without parens" do
      new_source = autocorrect_source("(a..b).#{method} 1")
      expect(new_source).to eq '(a..b).cover? 1'
    end

    it "autocorrects (a...b).#{method} without parens" do
      new_source = autocorrect_source("(a...b).#{method} 1")
      expect(new_source).to eq '(a...b).cover? 1'
    end

    it "autocorrects (a..b).#{method} with parens" do
      new_source = autocorrect_source("(a..b).#{method}(1)")
      expect(new_source).to eq '(a..b).cover?(1)'
    end

    it "autocorrects (a...b).#{method} with parens" do
      new_source = autocorrect_source("(a...b).#{method}(1)")
      expect(new_source).to eq '(a...b).cover?(1)'
    end
  end

  it 'formats the error message correctly for (a..b).include? 1' do
    expect_offense(<<~RUBY)
      (a..b).include? 1
             ^^^^^^^^ Use `Range#cover?` instead of `Range#include?`.
    RUBY
  end

  it 'formats the error message correctly for (a..b).member? 1' do
    expect_offense(<<~RUBY)
      (a..b).member? 1
             ^^^^^^^ Use `Range#cover?` instead of `Range#member?`.
    RUBY
  end
end
