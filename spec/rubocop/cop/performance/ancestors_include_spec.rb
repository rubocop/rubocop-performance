# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Performance::AncestorsInclude do
  subject(:cop) { described_class.new }

  it 'registers an offense and corrects when using `ancestors.include?`' do
    expect_offense(<<~RUBY)
      Class.ancestors.include?(Kernel)
            ^^^^^^^^^^^^^^^^^^ Use `<=` instead of `ancestors.include?`.
    RUBY

    expect_correction(<<~RUBY)
      Class <= Kernel
    RUBY
  end

  it 'does not register an offense when using `<=`' do
    expect_no_offenses(<<~RUBY)
      Class <= Kernel
    RUBY
  end
end
