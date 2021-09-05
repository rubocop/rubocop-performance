# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Performance::UnnecessaryStackframe, :config do
  it 'registers an offense when a block only yields' do
    expect_offense(<<~RUBY)
      def method(x)
        do_something { yield }
        ^^^^^^^^^^^^^^^^^^^^^^ Forward the received block directly instead of using `yield`.
      end
    RUBY
  end
end
