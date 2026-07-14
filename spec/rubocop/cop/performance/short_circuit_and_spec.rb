# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Performance::ShortCircuitAnd, :config do
  defs = <<~RUBY
    a = 42
    def foo?
      42
    end
  RUBY

  shared_examples 'logical_and' do |logical_and|
    it "registers an offense for a single misordered use of `#{logical_and}`" do
      expect_offense(<<~RUBY, logical_and: logical_and)
        #{defs}
        foo? #{logical_and} a
        ^^^^^^{logical_and}^^ Use short-circuit logic with cheaper expressions first to avoid unnecessary method calls.
      RUBY

      expect_correction(<<~RUBY)
        #{defs}
        a #{logical_and} foo?
      RUBY
    end

    it "doesn't register an offense for a single well ordered use of `#{logical_and}`" do
      expect_no_offenses(<<~RUBY)
        #{defs}
        a #{logical_and} foo?
      RUBY
    end

    it "registers offenses for multiple misordered uses of `#{logical_and}`" do
      expect_offense(<<~RUBY, logical_and: logical_and)
        #{defs}
        foo? #{logical_and} a #{logical_and} foo? #{logical_and} a
        ^^^^^^{logical_and}^^ Use short-circuit logic with cheaper expressions first to avoid unnecessary method calls.
        ^^^^^^{logical_and}^^^^{logical_and}^^^^^^^{logical_and}^^ Use short-circuit logic with cheaper expressions first to avoid unnecessary method calls.
      RUBY

      expect_correction(<<~RUBY)
        #{defs}
        a #{logical_and} a #{logical_and} foo? #{logical_and} foo?
      RUBY
    end

    it "doesn't register offenses for multiple misordered uses of `#{logical_and}`" do
      expect_no_offenses(<<~RUBY)
        #{defs}
        a #{logical_and} a #{logical_and} foo? #{logical_and} foo?
      RUBY
    end
  end

  include_examples 'logical_and', '&&'
  include_examples 'logical_and', 'and'
end
