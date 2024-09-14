# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Performance::DoubleStartEndWith, :config do
  context 'IncludeActiveSupportAliases: false' do
    let(:config) do
      RuboCop::Config.new('Performance/DoubleStartEndWith' => { 'IncludeActiveSupportAliases' => false })
    end

    context 'two #start_with? calls' do
      context 'with the same receiver' do
        context 'all parameters of the second call are pure' do
          it 'registers an offense and corrects' do
            expect_offense(<<~RUBY)
              x.start_with?(a, b) || x.start_with?("c", D)
              ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use `x.start_with?(a, b, "c", D)` instead of `x.start_with?(a, b) || x.start_with?("c", D)`.
            RUBY

            expect_correction(<<~RUBY)
              x.start_with?(a, b, "c", D)
            RUBY
          end
        end

        context 'one of the parameters of the second call is not pure' do
          it "doesn't register an offense" do
            expect_no_offenses('x.start_with?(a, "b") || x.start_with?(C, d)')
          end
        end

        context 'with safe navigation' do
          it 'registers an offense' do
            expect_offense(<<~RUBY)
              x&.start_with?(a, b) || x&.start_with?("c", D)
              ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use `x&.start_with?(a, b, "c", D)` instead of `x&.start_with?(a, b) || x&.start_with?("c", D)`.
            RUBY

            expect_correction(<<~RUBY)
              x&.start_with?(a, b, "c", D)
            RUBY
          end

          it 'registers an offense when the first start_with uses no safe navigation' do
            expect_offense(<<~RUBY)
              x.start_with?(a, b) || x&.start_with?("c", D)
              ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use `x.start_with?(a, b, "c", D)` instead of `x.start_with?(a, b) || x&.start_with?("c", D)`.
            RUBY

            expect_correction(<<~RUBY)
              x.start_with?(a, b, "c", D)
            RUBY
          end

          it 'registers an offense when the second start_with uses no safe navigation' do
            expect_offense(<<~RUBY)
              x&.start_with?(a, b) || x.start_with?("c", D)
              ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use `x&.start_with?(a, b, "c", D)` instead of `x&.start_with?(a, b) || x.start_with?("c", D)`.
            RUBY

            expect_correction(<<~RUBY)
              x&.start_with?(a, b, "c", D)
            RUBY
          end
        end
      end

      context 'with different receivers' do
        it "doesn't register an offense" do
          expect_no_offenses('x.start_with?("a") || y.start_with?("b")')
        end
      end
    end

    context 'two #end_with? calls' do
      context 'with the same receiver' do
        context 'all parameters of the second call are pure' do
          it 'registers an offense and corrects' do
            expect_offense(<<~RUBY)
              x.end_with?(a, b) || x.end_with?("c", D)
              ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use `x.end_with?(a, b, "c", D)` instead of `x.end_with?(a, b) || x.end_with?("c", D)`.
            RUBY

            expect_correction(<<~RUBY)
              x.end_with?(a, b, "c", D)
            RUBY
          end
        end

        context 'one of the parameters of the second call is not pure' do
          it "doesn't register an offense" do
            expect_no_offenses('x.end_with?(a, "b") || x.end_with?(C, d)')
          end
        end
      end

      context 'with different receivers' do
        it "doesn't register an offense" do
          expect_no_offenses('x.end_with?("a") || y.end_with?("b")')
        end
      end
    end

    context 'a .start_with? and .end_with? call with the same receiver' do
      it "doesn't register an offense" do
        expect_no_offenses('x.start_with?("a") || x.end_with?("b")')
      end
    end

    context 'two #starts_with? calls' do
      it "doesn't register an offense" do
        expect_no_offenses('x.starts_with?(a, b) || x.starts_with?("c", D)')
      end
    end

    context 'two #ends_with? calls' do
      it "doesn't register an offense" do
        expect_no_offenses('x.ends_with?(a, b) || x.ends_with?("c", D)')
      end
    end
  end

  context 'IncludeActiveSupportAliases: true' do
    let(:config) do
      RuboCop::Config.new('Performance/DoubleStartEndWith' => { 'IncludeActiveSupportAliases' => true })
    end

    context 'two #start_with? calls' do
      context 'with the same receiver' do
        context 'all parameters of the second call are pure' do
          it 'registers an offense and corrects' do
            expect_offense(<<~RUBY)
              x.start_with?(a, b) || x.start_with?("c", D)
              ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use `x.start_with?(a, b, "c", D)` instead of `x.start_with?(a, b) || x.start_with?("c", D)`.
            RUBY

            expect_correction(<<~RUBY)
              x.start_with?(a, b, "c", D)
            RUBY
          end
        end
      end
    end

    context 'two #end_with? calls' do
      context 'with the same receiver' do
        context 'all parameters of the second call are pure' do
          it 'registers an offense and corrects' do
            expect_offense(<<~RUBY)
              x.end_with?(a, b) || x.end_with?("c", D)
              ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use `x.end_with?(a, b, "c", D)` instead of `x.end_with?(a, b) || x.end_with?("c", D)`.
            RUBY

            expect_correction(<<~RUBY)
              x.end_with?(a, b, "c", D)
            RUBY
          end
        end
      end
    end

    context 'two #starts_with? calls' do
      context 'with the same receiver' do
        context 'all parameters of the second call are pure' do
          it 'registers an offense and corrects' do
            expect_offense(<<~RUBY)
              x.starts_with?(a, b) || x.starts_with?("c", D)
              ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use `x.starts_with?(a, b, "c", D)` instead of `x.starts_with?(a, b) || x.starts_with?("c", D)`.
            RUBY

            expect_correction(<<~RUBY)
              x.starts_with?(a, b, "c", D)
            RUBY
          end
        end

        context 'one of the parameters of the second call is not pure' do
          it "doesn't register an offense" do
            expect_no_offenses(<<~RUBY)
              x.starts_with?(a, "b") || x.starts_with?(C, d)
            RUBY
          end
        end
      end

      context 'with different receivers' do
        it "doesn't register an offense" do
          expect_no_offenses('x.starts_with?("a") || y.starts_with?("b")')
        end
      end
    end

    context 'two #ends_with? calls' do
      context 'with the same receiver' do
        context 'all parameters of the second call are pure' do
          it 'registers an offense and corrects' do
            expect_offense(<<~RUBY)
              x.ends_with?(a, b) || x.ends_with?("c", D)
              ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use `x.ends_with?(a, b, "c", D)` instead of `x.ends_with?(a, b) || x.ends_with?("c", D)`.
            RUBY

            expect_correction(<<~RUBY)
              x.ends_with?(a, b, "c", D)
            RUBY
          end
        end

        context 'one of the parameters of the second call is not pure' do
          it "doesn't register an offense" do
            expect_no_offenses('x.ends_with?(a, "b") || x.ends_with?(C, d)')
          end
        end
      end

      context 'with different receivers' do
        it "doesn't register an offense" do
          expect_no_offenses('x.ends_with?("a") || y.ends_with?("b")')
        end
      end
    end
  end
end
