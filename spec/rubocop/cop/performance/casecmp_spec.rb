# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Performance::Casecmp do
  subject(:cop) { described_class.new }

  shared_examples 'selectors' do |selector|
    it "registers an offense and corrects str.#{selector} ==" do
      expect_offense(<<~RUBY, selector: selector)
        str.#{selector} == 'string'
        ^^^^^{selector}^^^^^^^^^^^^ Use `str.casecmp('string').zero?` instead of `str.#{selector} == 'string'`.
      RUBY

      expect_correction(<<~RUBY)
        str.casecmp('string').zero?
      RUBY
    end

    it "registers an offense and corrects str.#{selector} == with parens around arg" do
      expect_offense(<<~RUBY, selector: selector)
        str.#{selector} == ('string')
        ^^^^^{selector}^^^^^^^^^^^^^^ Use `str.casecmp('string').zero?` instead of `str.#{selector} == ('string')`.
      RUBY

      expect_correction(<<~RUBY)
        str.casecmp('string').zero?
      RUBY
    end

    it "registers an offense and corrects str.#{selector} !=" do
      expect_offense(<<~RUBY, selector: selector)
        str.#{selector} != 'string'
        ^^^^^{selector}^^^^^^^^^^^^ Use `str.casecmp('string').zero?` instead of `str.#{selector} != 'string'`.
      RUBY

      expect_correction(<<~RUBY)
        !str.casecmp('string').zero?
      RUBY
    end

    it "registers an offense and corrects str.#{selector} != with parens around arg" do
      expect_offense(<<~RUBY, selector: selector)
        str.#{selector} != ('string')
        ^^^^^{selector}^^^^^^^^^^^^^^ Use `str.casecmp('string').zero?` instead of `str.#{selector} != ('string')`.
      RUBY

      expect_correction(<<~RUBY)
        !str.casecmp('string').zero?
      RUBY
    end

    it "registers an offense and corrects str.#{selector}.eql? without parens" do
      expect_offense(<<~RUBY, selector: selector)
        str.#{selector}.eql? 'string'
        ^^^^^{selector}^^^^^^^^^^^^^^ Use `str.casecmp('string').zero?` instead of `str.#{selector}.eql? 'string'`.
      RUBY

      expect_correction(<<~RUBY)
        str.casecmp('string').zero?
      RUBY
    end

    it "registers an offense and corrects str.#{selector}.eql? with parens" do
      expect_offense(<<~RUBY, selector: selector)
        str.#{selector}.eql?('string')
        ^^^^^{selector}^^^^^^^^^^^^^^^ Use `str.casecmp('string').zero?` instead of `str.#{selector}.eql?('string')`.
      RUBY

      expect_correction(<<~RUBY)
        str.casecmp('string').zero?
      RUBY
    end

    it "registers an offense and corrects str.#{selector}.eql? with parens and funny spacing" do
      expect_offense(<<~RUBY, selector: selector)
        str.#{selector}.eql? ( 'string' )
        ^^^^^{selector}^^^^^^^^^^^^^^^^^^ Use `str.casecmp( 'string' ).zero?` instead of `str.#{selector}.eql? ( 'string' )`.
      RUBY

      expect_correction(<<~RUBY)
        str.casecmp( 'string' ).zero?
      RUBY
    end

    it "registers an offense and corrects == str.#{selector}" do
      expect_offense(<<~RUBY, selector: selector)
        'string' == str.#{selector}
        ^^^^^^^^^^^^^^^^^{selector} Use `str.casecmp('string').zero?` instead of `'string' == str.#{selector}`.
      RUBY

      expect_correction(<<~RUBY)
        str.casecmp('string').zero?
      RUBY
    end

    it "registers an offense and corrects string with parens == str.#{selector}" do
      expect_offense(<<~RUBY, selector: selector)
        ('string') == str.#{selector}
        ^^^^^^^^^^^^^^^^^^^{selector} Use `str.casecmp('string').zero?` instead of `('string') == str.#{selector}`.
      RUBY

      expect_correction(<<~RUBY)
        str.casecmp('string').zero?
      RUBY
    end

    it "registers an offense and corrects string != str.#{selector}" do
      expect_offense(<<~RUBY, selector: selector)
        'string' != str.#{selector}
        ^^^^^^^^^^^^^^^^^{selector} Use `str.casecmp('string').zero?` instead of `'string' != str.#{selector}`.
      RUBY

      expect_correction(<<~RUBY)
        !str.casecmp('string').zero?
      RUBY
    end

    it 'registers an offense and corrects string with parens and funny spacing ' \
       "eql? str.#{selector}" do
      expect_offense(<<~RUBY, selector: selector)
        ( 'string' ).eql? str.#{selector}
        ^^^^^^^^^^^^^^^^^^^^^^^{selector} Use `str.casecmp( 'string' ).zero?` instead of `( 'string' ).eql? str.#{selector}`.
      RUBY

      expect_correction(<<~RUBY)
        str.casecmp( 'string' ).zero?
      RUBY
    end

    it "registers an offense and corrects string.eql? str.#{selector} without parens " do
      expect_offense(<<~RUBY, selector: selector)
        'string'.eql? str.#{selector}
        ^^^^^^^^^^^^^^^^^^^{selector} Use `str.casecmp('string').zero?` instead of `'string'.eql? str.#{selector}`.
      RUBY

      expect_correction(<<~RUBY)
        str.casecmp('string').zero?
      RUBY
    end

    it "registers an offense and corrects string.eql? str.#{selector} with parens " do
      expect_offense(<<~RUBY, selector: selector)
        'string'.eql?(str.#{selector})
        ^^^^^^^^^^^^^^^^^^^{selector}^ Use `str.casecmp('string').zero?` instead of `'string'.eql?(str.#{selector})`.
      RUBY

      expect_correction(<<~RUBY)
        str.casecmp('string').zero?
      RUBY
    end

    it "registers an offense and corrects obj.#{selector} == str.#{selector}" do
      expect_offense(<<~RUBY, selector: selector)
        obj.#{selector} == str.#{selector}
        ^^^^^{selector}^^^^^^^^^{selector} Use `obj.casecmp(str).zero?` instead of `obj.#{selector} == str.#{selector}`.
      RUBY

      expect_correction(<<~RUBY)
        obj.casecmp(str).zero?
      RUBY
    end

    it "registers an offense and corrects obj.#{selector} eql? str.#{selector}" do
      expect_offense(<<~RUBY, selector: selector)
        obj.#{selector}.eql? str.#{selector}
        ^^^^^{selector}^^^^^^^^^^^{selector} Use `obj.casecmp(str).zero?` instead of `obj.#{selector}.eql? str.#{selector}`.
      RUBY

      expect_correction(<<~RUBY)
        obj.casecmp(str).zero?
      RUBY
    end

    it "doesn't report an offense for variable == str.#{selector}" do
      expect_no_offenses(<<~RUBY)
        var = "a"
        var == str.#{selector}
      RUBY
    end

    it "doesn't report an offense for str.#{selector} == variable" do
      expect_no_offenses(<<~RUBY)
        var = "a"
        str.#{selector} == var
      RUBY
    end

    it "doesn't report an offense for obj.method == str.#{selector}" do
      expect_no_offenses("obj.method == str.#{selector}")
    end

    it "doesn't report an offense for str.#{selector} == obj.method" do
      expect_no_offenses("str.#{selector} == obj.method")
    end
  end

  it_behaves_like('selectors', 'upcase')
  it_behaves_like('selectors', 'downcase')
end
