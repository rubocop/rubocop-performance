# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Performance::DeleteSuffix, :config do
  let(:cop_config) { { 'SafeMultiline' => safe_multiline } }
  let(:safe_multiline) { true }

  context 'TargetRubyVersion <= 2.4', :ruby24 do
    it "does not register an offense when using `gsub(/suffix\z/, '')`" do
      expect_no_offenses(<<~RUBY)
        str.gsub(/suffix\\z/, '')
      RUBY
    end

    it "does not register an offense when using `gsub!(/suffix\z/, '')`" do
      expect_no_offenses(<<~RUBY)
        str.gsub!(/suffix\\z/, '')
      RUBY
    end

    it "does not register an offense when using `sub(/suffix\z/, '')`" do
      expect_no_offenses(<<~RUBY)
        str.sub(/suffix\\z/, '')
      RUBY
    end

    it "does not register an offense when using `sub!(/suffix\z/, '')`" do
      expect_no_offenses(<<~RUBY)
        str.sub!(/suffix\\z/, '')
      RUBY
    end
  end

  context 'TargetRubyVersion >= 2.5', :ruby25 do
    context 'when using `\z` as ending pattern' do
      it "registers an offense and corrects when `gsub(/suffix\z/, '')`" do
        expect_offense(<<~RUBY)
          str.gsub(/suffix\\z/, '')
              ^^^^ Use `delete_suffix` instead of `gsub`.
        RUBY

        expect_correction(<<~RUBY)
          str.delete_suffix('suffix')
        RUBY
      end

      it "registers an offense and corrects when `gsub!(/suffix\z/, '')`" do
        expect_offense(<<~RUBY)
          str.gsub!(/suffix\\z/, '')
              ^^^^^ Use `delete_suffix!` instead of `gsub!`.
        RUBY

        expect_correction(<<~RUBY)
          str.delete_suffix!('suffix')
        RUBY
      end

      it "registers an offense and corrects when `sub(/suffix\z/, '')`" do
        expect_offense(<<~RUBY)
          str.sub(/suffix\\z/, '')
              ^^^ Use `delete_suffix` instead of `sub`.
        RUBY

        expect_correction(<<~RUBY)
          str.delete_suffix('suffix')
        RUBY
      end

      it "registers an offense and corrects when `sub!(/suffix\z/, '')`" do
        expect_offense(<<~RUBY)
          str.sub!(/suffix\\z/, '')
              ^^^^ Use `delete_suffix!` instead of `sub!`.
        RUBY

        expect_correction(<<~RUBY)
          str.delete_suffix!('suffix')
        RUBY
      end
    end

    context 'when using `$` as ending pattern' do
      context 'when `SafeMultiline: true`' do
        let(:safe_multiline) { true }

        it 'does not register an offense and corrects when using `gsub`' do
          expect_no_offenses(<<~RUBY)
            str.gsub(/suffix$/, '')
          RUBY
        end

        it 'does not register an offense and corrects when using `gsub!`' do
          expect_no_offenses(<<~RUBY)
            str.gsub!(/suffix$/, '')
          RUBY
        end

        it 'does not register an offense and corrects when using `sub`' do
          expect_no_offenses(<<~RUBY)
            str.sub(/suffix$/, '')
          RUBY
        end

        it 'does not register an offense and corrects when using `sub!`' do
          expect_no_offenses(<<~RUBY)
            str.sub!(/suffix$/, '')
          RUBY
        end
      end

      context 'when `SafeMultiline: false`' do
        let(:safe_multiline) { false }

        it 'registers an offense and corrects when using `gsub`' do
          expect_offense(<<~RUBY)
            str.gsub(/suffix$/, '')
                ^^^^ Use `delete_suffix` instead of `gsub`.
          RUBY

          expect_correction(<<~RUBY)
            str.delete_suffix('suffix')
          RUBY
        end

        it 'registers an offense and corrects when using `gsub!`' do
          expect_offense(<<~RUBY)
            str.gsub!(/suffix$/, '')
                ^^^^^ Use `delete_suffix!` instead of `gsub!`.
          RUBY

          expect_correction(<<~RUBY)
            str.delete_suffix!('suffix')
          RUBY
        end

        it 'registers an offense and corrects when using `sub`' do
          expect_offense(<<~RUBY)
            str.sub(/suffix$/, '')
                ^^^ Use `delete_suffix` instead of `sub`.
          RUBY

          expect_correction(<<~RUBY)
            str.delete_suffix('suffix')
          RUBY
        end

        it 'registers an offense and corrects when using `sub!`' do
          expect_offense(<<~RUBY)
            str.sub!(/suffix$/, '')
                ^^^^ Use `delete_suffix!` instead of `sub!`.
          RUBY

          expect_correction(<<~RUBY)
            str.delete_suffix!('suffix')
          RUBY
        end
      end
    end

    context 'when using non-ending pattern' do
      it 'does not register an offense when using `gsub`' do
        expect_no_offenses(<<~RUBY)
          str.gsub(/pattern/, '')
        RUBY
      end

      it 'does not register an offense when using `gsub!`' do
        expect_no_offenses(<<~RUBY)
          str.gsub!(/pattern/, '')
        RUBY
      end

      it 'does not register an offense when using `sub`' do
        expect_no_offenses(<<~RUBY)
          str.sub(/pattern/, '')
        RUBY
      end

      it 'does not register an offense when using `sub!`' do
        expect_no_offenses(<<~RUBY)
          str.sub!(/pattern/, '')
        RUBY
      end
    end

    context 'with starting pattern `\A` and ending pattern `\z`' do
      it 'does not register an offense and corrects when using `gsub`' do
        expect_no_offenses(<<~RUBY)
          str.gsub(/\\Asuffix\\z/, '')
        RUBY
      end

      it 'does not register an offense and corrects when using `gsub!`' do
        expect_no_offenses(<<~RUBY)
          str.gsub!(/\\Asuffix\\z/, '')
        RUBY
      end

      it 'does not register an offense and corrects when using `sub`' do
        expect_no_offenses(<<~RUBY)
          str.sub(/\\Asuffix\\z/, '')
        RUBY
      end

      it 'does not register an offense and corrects when using `sub!`' do
        expect_no_offenses(<<~RUBY)
          str.sub!(/\\Asuffix\\z/, '')
        RUBY
      end
    end

    context 'when using a non-blank string as replacement string' do
      it 'does not register an offense and corrects when using `gsub`' do
        expect_no_offenses(<<~RUBY)
          str.gsub(/suffix\\z/, 'foo')
        RUBY
      end

      it 'does not register an offense and corrects when using `gsub!`' do
        expect_no_offenses(<<~RUBY)
          str.gsub!(/suffix\\z/, 'foo')
        RUBY
      end

      it 'does not register an offense and corrects when using `sub`' do
        expect_no_offenses(<<~RUBY)
          str.sub(/suffix\\z/, 'foo')
        RUBY
      end

      it 'does not register an offense and corrects when using `sub!`' do
        expect_no_offenses(<<~RUBY)
          str.sub!(/suffix\\z/, 'foo')
        RUBY
      end
    end

    it 'does not register an offense when using `delete_suffix`' do
      expect_no_offenses(<<~RUBY)
        str.delete_suffix('suffix')
      RUBY
    end

    it 'does not register an offense when using `delete_suffix!`' do
      expect_no_offenses(<<~RUBY)
        str.delete_suffix!('suffix')
      RUBY
    end
  end
end
