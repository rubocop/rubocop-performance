# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Performance::SelectMap, :config do
  context 'when TargetRubyVersion >= 2.7', :ruby27 do
    it 'registers an offense when using `select(&:...).map(&:...)`' do
      expect_offense(<<~RUBY)
        ary.select(&:present?).map(&:to_i)
            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use `filter_map` instead of `select.map`.
      RUBY
    end

    it 'registers an offense when using `select(&:...)&.map(&:...)`' do
      expect_offense(<<~RUBY)
        ary&.select(&:present?)&.map(&:to_i)
             ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use `filter_map` instead of `select.map`.
      RUBY
    end

    it 'registers an offense when using `filter(&:...).map(&:...)`' do
      expect_offense(<<~RUBY)
        ary.filter(&:present?).map(&:to_i)
            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use `filter_map` instead of `filter.map`.
      RUBY
    end

    it 'registers an offense when using `select(&:...).map(&:...)` with safe navigation operator' do
      expect_offense(<<~RUBY)
        ary&.select(&:present?).map(&:to_i)
             ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use `filter_map` instead of `select.map`.
      RUBY
    end

    it 'registers an offense when using `filter(&:...).map(&:...)` with safe navitaion operator' do
      expect_offense(<<~RUBY)
        ary&.filter(&:present?).map(&:to_i)
             ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use `filter_map` instead of `filter.map`.
      RUBY
    end

    it 'registers an offense when using `select { ... }.map { ... }`' do
      expect_offense(<<~RUBY)
        ary.select { |o| o.present? }.map { |o| o.to_i }
            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use `filter_map` instead of `select.map`.
      RUBY
    end

    it 'registers an offense when using `select { ... }&.map { ... }`' do
      expect_offense(<<~RUBY)
        ary&.select { |o| o.present? }&.map { |o| o.to_i }
             ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use `filter_map` instead of `select.map`.
      RUBY
    end

    it 'registers an offense when using `select { ... }.map(&:...)`' do
      expect_offense(<<~RUBY)
        ary.select { |o| o.present? }.map(&:to_i)
            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use `filter_map` instead of `select.map`.
      RUBY
    end

    it 'registers an offense when using `select(&:...).map { ... }`' do
      expect_offense(<<~RUBY)
        ary.select(&:present?).map { |o| o.to_i }
            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use `filter_map` instead of `select.map`.
      RUBY
    end

    it 'registers an offense when using `select(&:...).map(&:...)` in method chain' do
      expect_offense(<<~RUBY)
        ary.do_something.select(&:present?).map(&:to_i).max
                         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use `filter_map` instead of `select.map`.
      RUBY
    end

    it 'registers an offense when using `select(&:...).map(&:...)` without receiver' do
      expect_offense(<<~RUBY)
        select(&:present?).map(&:to_i)
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use `filter_map` instead of `select.map`.
      RUBY
    end

    it 'does not register an offense when using `filter_map`' do
      expect_no_offenses(<<~RUBY)
        ary.filter_map { |o| o.to_i if o.present? }
      RUBY
    end

    it 'does not register an offense when using `select`' do
      expect_no_offenses(<<~RUBY)
        ary.select(&:present?)
      RUBY
    end

    it 'does not register an offense when using `select(key: value).map`' do
      expect_no_offenses(<<~RUBY)
        ary.do_something.select(key: value).map(&:to_i)
      RUBY
    end

    it 'does not register an offense when using `select` with assignment' do
      expect_no_offenses(<<~RUBY)
        ret = select
      RUBY
    end

    it 'does not register an offense when using `select(&:...).stranger.map(&:...)`' do
      expect_no_offenses(<<~RUBY)
        ary.do_something.select(&:present?).stranger.map(&:to_i).max
      RUBY
    end

    it 'does not register an offense when using `select { ... }.stranger.map { ... }`' do
      expect_no_offenses(<<~RUBY)
        ary.select { |o| o.present? }.stranger.map { |o| o.to_i }
      RUBY
    end

    #
    # `compact` is not compatible with `filter_map`.
    #
    # [true, false, nil].compact              #=> [true, false]
    # [true, false, nil].filter_map(&:itself) #=> [true]
    #
    # Use `Performance/MapCompact` cop.
    #
    it 'does not register an offense when using `map(&:...).compact`' do
      expect_no_offenses(<<~RUBY)
        ary.map(&:to_i).compact
      RUBY
    end
  end

  context 'when TargetRubyVersion <= 2.6', :ruby26, unsupported_on: :prism do
    it 'does not register an offense when using `select.map`' do
      expect_no_offenses(<<~RUBY)
        ary.select(&:present?).map(&:to_i)
      RUBY
    end
  end

  context 'when using numbered parameter', :ruby27 do
    it 'registers an offense when using `select...map`' do
      expect_offense(<<~RUBY)
        ary.select { _1.present? }.map { _1.to_i }
            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use `filter_map` instead of `select.map`.
      RUBY
    end
  end

  context 'when using `it` parameter', :ruby34, unsupported_on: :parser do
    it 'registers an offense when using `select...map`' do
      expect_offense(<<~RUBY)
        ary.select { it.present? }.map { it.to_i }
            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use `filter_map` instead of `select.map`.
      RUBY
    end
  end

  context 'when `select` is the body of a block' do
    context 'with a named block parameter' do
      it 'does not register an offense when `map` is called on the outer block' do
        expect_no_offenses(<<~RUBY)
          groups.map { |x| x.select(&:active?) }.map(&:size)
        RUBY
      end

      it 'registers an offense for the chain inside the block' do
        expect_offense(<<~RUBY)
          items.each { |x| x.select(&:x).map(&:y) }
                             ^^^^^^^^^^^^^^^^^^^^ Use `filter_map` instead of `select.map`.
        RUBY
      end
    end

    context 'with a numbered parameter', :ruby27 do
      it 'does not register an offense when `map` is called on the outer block' do
        expect_no_offenses(<<~RUBY)
          groups.map { _1.select(&:active?) }.map(&:size)
        RUBY
      end

      it 'registers an offense for the chain inside the block' do
        expect_offense(<<~RUBY)
          items.each { _1.select(&:x).map(&:y) }
                          ^^^^^^^^^^^^^^^^^^^^ Use `filter_map` instead of `select.map`.
        RUBY
      end
    end

    context 'with the `it` parameter', :ruby34, unsupported_on: :parser do
      it 'does not register an offense when `map` is called on the outer block' do
        expect_no_offenses(<<~RUBY)
          groups.map { it.select(&:active?) }.map(&:size)
        RUBY
      end

      it 'registers an offense for the chain inside the block' do
        expect_offense(<<~RUBY)
          items.each { it.select(&:x).map(&:y) }
                          ^^^^^^^^^^^^^^^^^^^^ Use `filter_map` instead of `select.map`.
        RUBY
      end
    end
  end

  context 'when `select` is an argument of `map`' do
    context 'with a named block parameter' do
      it 'does not register an offense' do
        expect_no_offenses(<<~RUBY)
          map(ary.select { |x| x.x })
        RUBY
      end
    end

    context 'with a numbered parameter', :ruby27 do
      it 'does not register an offense' do
        expect_no_offenses(<<~RUBY)
          map(ary.select { _1.x })
        RUBY
      end
    end

    context 'with the `it` parameter', :ruby34, unsupported_on: :parser do
      it 'does not register an offense' do
        expect_no_offenses(<<~RUBY)
          map(ary.select { it.x })
        RUBY
      end
    end
  end
end
