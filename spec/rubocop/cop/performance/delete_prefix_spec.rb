# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Performance::DeletePrefix, :config do
  subject(:cop) { described_class.new(config) }

  context 'TargetRubyVersion <= 2.4', :ruby24 do
    it "does not register an offense when using `gsub(/\Aprefix/, '')`" do
      expect_no_offenses(<<~RUBY)
        str.gsub(/\\Aprefix/, '')
      RUBY
    end

    it "does not register an offense when using `gsub!(/\Aprefix/, '')`" do
      expect_no_offenses(<<~RUBY)
        str.gsub!(/\\Aprefix/, '')
      RUBY
    end

    it "does not register an offense when using `sub(/\Aprefix/, '')`" do
      expect_no_offenses(<<~RUBY)
        str.sub(/\\Aprefix/, '')
      RUBY
    end

    it "does not register an offense when using `sub!(/\Aprefix/, '')`" do
      expect_no_offenses(<<~RUBY)
        str.sub!(/\\Aprefix/, '')
      RUBY
    end
  end

  context 'TargetRubyVersion >= 2.5', :ruby25 do
    context 'when using `\A` as starting pattern' do
      it "registers an offense and corrects when `gsub(/\Aprefix/, '')`" do
        expect_offense(<<~RUBY)
          str.gsub(/\\Aprefix/, '')
              ^^^^ Use `delete_prefix` instead of `gsub`.
        RUBY

        expect_correction(<<~RUBY)
          str.delete_prefix('prefix')
        RUBY
      end

      it "registers an offense and corrects when `gsub!(/\Aprefix/, '')`" do
        expect_offense(<<~RUBY)
          str.gsub!(/\\Aprefix/, '')
              ^^^^^ Use `delete_prefix!` instead of `gsub!`.
        RUBY

        expect_correction(<<~RUBY)
          str.delete_prefix!('prefix')
        RUBY
      end

      it "registers an offense and corrects when `sub(/\Aprefix/, '')`" do
        expect_offense(<<~RUBY)
          str.sub(/\\Aprefix/, '')
              ^^^ Use `delete_prefix` instead of `sub`.
        RUBY

        expect_correction(<<~RUBY)
          str.delete_prefix('prefix')
        RUBY
      end

      it "registers an offense and corrects when `sub!(/\Aprefix/, '')`" do
        expect_offense(<<~RUBY)
          str.sub!(/\\Aprefix/, '')
              ^^^^ Use `delete_prefix!` instead of `sub!`.
        RUBY

        expect_correction(<<~RUBY)
          str.delete_prefix!('prefix')
        RUBY
      end
    end

    context 'when using `^` as starting pattern' do
      it 'registers an offense and corrects when using `gsub`' do
        expect_offense(<<~RUBY)
          str.gsub(/^prefix/, '')
              ^^^^ Use `delete_prefix` instead of `gsub`.
        RUBY

        expect_correction(<<~RUBY)
          str.delete_prefix('prefix')
        RUBY
      end

      it 'registers an offense and corrects when using `gsub!`' do
        expect_offense(<<~RUBY)
          str.gsub!(/^prefix/, '')
              ^^^^^ Use `delete_prefix!` instead of `gsub!`.
        RUBY

        expect_correction(<<~RUBY)
          str.delete_prefix!('prefix')
        RUBY
      end

      it 'registers an offense and corrects when using `sub`' do
        expect_offense(<<~RUBY)
          str.sub(/^prefix/, '')
              ^^^ Use `delete_prefix` instead of `sub`.
        RUBY

        expect_correction(<<~RUBY)
          str.delete_prefix('prefix')
        RUBY
      end

      it 'registers an offense and corrects when using `sub!`' do
        expect_offense(<<~RUBY)
          str.sub!(/^prefix/, '')
              ^^^^ Use `delete_prefix!` instead of `sub!`.
        RUBY

        expect_correction(<<~RUBY)
          str.delete_prefix!('prefix')
        RUBY
      end
    end

    context 'when using non-starting pattern' do
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
          str.gsub(/\\Aprefix\\z/, '')
        RUBY
      end

      it 'does not register an offense and corrects when using `gsub!`' do
        expect_no_offenses(<<~RUBY)
          str.gsub!(/\\Aprefix\\z/, '')
        RUBY
      end

      it 'does not register an offense and corrects when using `sub`' do
        expect_no_offenses(<<~RUBY)
          str.sub(/\\Aprefix\\z/, '')
        RUBY
      end

      it 'does not register an offense and corrects when using `sub!`' do
        expect_no_offenses(<<~RUBY)
          str.sub!(/\\Aprefix\\z/, '')
        RUBY
      end
    end

    context 'when using a non-blank string as replacement string' do
      it 'does not register an offense and corrects when using `gsub`' do
        expect_no_offenses(<<~RUBY)
          str.gsub(/\\Aprefix/, 'foo')
        RUBY
      end

      it 'does not register an offense and corrects when using `gsub!`' do
        expect_no_offenses(<<~RUBY)
          str.gsub!(/\\Aprefix/, 'foo')
        RUBY
      end

      it 'does not register an offense and corrects when using `sub`' do
        expect_no_offenses(<<~RUBY)
          str.sub(/\\Aprefix/, 'foo')
        RUBY
      end

      it 'does not register an offense and corrects when using `sub!`' do
        expect_no_offenses(<<~RUBY)
          str.sub!(/\\Aprefix/, 'foo')
        RUBY
      end
    end

    it 'does not register an offense when using `delete_prefix`' do
      expect_no_offenses(<<~RUBY)
        str.delete_prefix('prefix')
      RUBY
    end

    it 'does not register an offense when using `delete_prefix!`' do
      expect_no_offenses(<<~RUBY)
        str.delete_prefix!('prefix')
      RUBY
    end
  end
end
