# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Performance::ConditionalDefinition, :config do
  %i[
    RUBY_VERSION
    RUBY_PLATFORM
    RUBY_PATCHLEVEL
    RUBY_ENGINE
    RUBY_DESCRIPTION
  ].each do |constant|
    %i[< <= === >= > =~ ===].each do |operator|
      it "registers an offense when using `#{operator}` comparison with `#{constant}` as LHS" do
        expect_offense(<<~RUBY)
          def foo
          ^^^^^^^ Move conditional logic outside of the method body definition to improve performance by avoiding repeated evaluation of constant condition.
            if #{constant} #{operator} '3.0'
              1
            else
              2
            end
          end
        RUBY
      end

      it "registers an offense when using `#{operator}` comparison with `#{constant}` as RHS" do
        expect_offense(<<~RUBY)
          def foo
          ^^^^^^^ Move conditional logic outside of the method body definition to improve performance by avoiding repeated evaluation of constant condition.
            if '3.0' #{operator} #{constant}
              1
            else
              2
            end
          end
        RUBY
      end
    end
  end

  it 'does not register an offense when conditional logic is moved outside of method definition' do
    expect_no_offenses(<<~RUBY)
      if RUBY_VERSION < '4.0.'
        def answer
          42
        end
      else
        def answer
          239
        end
      end
    RUBY
  end
end
