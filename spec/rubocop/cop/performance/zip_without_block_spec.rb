# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Performance::ZipWithoutBlock, :config do
  context 'when using map with array literal' do
    it 'registers an offense and corrects to use zip with no arguments' do
      expect_offense(<<~RUBY)
        [1, 2, 3].map { |id| [id] }
                  ^^^^^^^^^^^^^^^^^ Use `zip` without a block argument instead.
      RUBY

      expect_correction(<<~RUBY)
        [1, 2, 3].zip
      RUBY
    end
  end

  context 'when using map with a short iterator name' do
    it 'registers an offense and corrects to use zip with no arguments' do
      expect_offense(<<~RUBY)
        [1, 2, 3].map { |e| [e] }
                  ^^^^^^^^^^^^^^^ Use `zip` without a block argument instead.
      RUBY

      expect_correction(<<~RUBY)
        [1, 2, 3].zip
      RUBY
    end
  end

  context 'when using map on a range with another iterator name' do
    it 'registers an offense and corrects' do
      expect_offense(<<~RUBY)
        (1..3).map { |x| [x] }
               ^^^^^^^^^^^^^^^ Use `zip` without a block argument instead.
      RUBY

      expect_correction(<<~RUBY)
        (1..3).zip
      RUBY
    end
  end

  context 'when using map in a do end block' do
    it 'registers an offense and corrects' do
      expect_offense(<<~RUBY)
        (a..b).map do
               ^^^^^^ Use `zip` without a block argument instead.
          |m| [m]
        end
      RUBY

      expect_correction(<<~RUBY)
        (a..b).zip
      RUBY
    end
  end

  context 'with a safe operator' do
    context 'when using map with array literal' do
      it 'registers an offense and corrects to use zip with no arguments' do
        expect_offense(<<~RUBY)
          [1, 2, 3]&.map { |id| [id] }
                     ^^^^^^^^^^^^^^^^^ Use `zip` without a block argument instead.
        RUBY

        expect_correction(<<~RUBY)
          [1, 2, 3]&.zip
        RUBY
      end
    end

    context 'when using map with a short iterator name' do
      it 'registers an offense and corrects to use zip with no arguments' do
        expect_offense(<<~RUBY)
          [1, 2, 3]&.map { |e| [e] }
                     ^^^^^^^^^^^^^^^ Use `zip` without a block argument instead.
        RUBY

        expect_correction(<<~RUBY)
          [1, 2, 3]&.zip
        RUBY
      end
    end

    context 'when using map on a range with another iterator name' do
      it 'registers an offense and corrects' do
        expect_offense(<<~RUBY)
          (1..3)&.map { |x| [x] }
                  ^^^^^^^^^^^^^^^ Use `zip` without a block argument instead.
        RUBY

        expect_correction(<<~RUBY)
          (1..3)&.zip
        RUBY
      end
    end

    context 'when using map in a do end block' do
      it 'registers an offense and corrects' do
        expect_offense(<<~RUBY)
          (a..b)&.map do
                  ^^^^^^ Use `zip` without a block argument instead.
            |m| [m]
          end
        RUBY

        expect_correction(<<~RUBY)
          (a..b)&.zip
        RUBY
      end
    end
  end

  context 'when using map in a chain' do
    it 'registers an offense and corrects' do
      expect_offense(<<~RUBY)
        [nil, tuple].flatten.map { |e| [e] }.call
                             ^^^^^^^^^^^^^^^ Use `zip` without a block argument instead.
      RUBY

      expect_correction(<<~RUBY)
        [nil, tuple].flatten.zip.call
      RUBY
    end
  end

  context 'when the map block does not contain an array literal' do
    it 'does not register an offense' do
      expect_no_offenses(<<~RUBY)
        [1, 2, 3].map { |id| id }
      RUBY
    end
  end

  context 'when using map with an array literal containing multiple elements' do
    it 'does not register an offense' do
      expect_no_offenses(<<~RUBY)
        [1, 2, 3].map { |id| [id, id] }
      RUBY
    end
  end

  context 'when using other iterators such as' do
    context 'when using collect' do
      it 'registers an offense as collect is an alias of map' do
        expect_offense(<<~RUBY)
          [1, 2, 3].collect { |id| [id] }
                    ^^^^^^^^^^^^^^^^^^^^^ Use `zip` without a block argument instead.
        RUBY

        expect_correction(<<~RUBY)
          [1, 2, 3].zip
        RUBY
      end

      it 'registers an offense for collect with a numblock', :ruby27 do
        expect_offense(<<~RUBY)
          [1, 2, 3].collect { [_1] }
                    ^^^^^^^^^^^^^^^^ Use `zip` without a block argument instead.
        RUBY

        expect_correction(<<~RUBY)
          [1, 2, 3].zip
        RUBY
      end
    end

    context 'when using select with an array literal' do
      it 'does not register an offense' do
        expect_no_offenses(<<~RUBY)
          [1, 2, 3].select { |id| [id] }
        RUBY
      end
    end

    context 'when calling filter_map' do
      it 'does not register an offense' do
        expect_no_offenses(<<~RUBY)
          [1, 2, 3].filter_map {|id| [id]}
        RUBY
      end
    end

    context 'when calling flat_map' do
      it 'does not register an offense' do
        expect_no_offenses(<<~RUBY)
          [1, 2, 3].flat_map {|id| [id]}
        RUBY
      end
    end
  end

  context 'when using map with doubly wrapped arrays' do
    it 'does not register an offense' do
      expect_no_offenses(<<~RUBY)
        [1, 2, 3].map { |id| [[id]] }
      RUBY
    end
  end

  context 'when using map with addition' do
    it 'does not register an offense' do
      expect_no_offenses(<<~RUBY)
        [1, 2, 3].map { |id| id + 1 }
      RUBY
    end
  end

  context 'when using map with array addition' do
    it 'does not register an offense' do
      expect_no_offenses(<<~RUBY)
        [1, 2, 3].map { |id| [id] + [id] }
      RUBY
    end
  end

  context 'when using map with indexing into an array' do
    it 'does not register an offense' do
      expect_no_offenses(<<~RUBY)
        [1, 2, 3].map { |id| [id][id] }
      RUBY
    end
  end

  context 'when calling map with no arguments i.e. no parent' do
    it 'does not register an offense' do
      expect_no_offenses(<<~RUBY)
        [1, 2, 3].map
      RUBY
    end
  end

  context 'when calling map with an empty block' do
    it 'does not register an offense' do
      expect_no_offenses(<<~RUBY)
        [1, 2, 3].map {}
      RUBY
    end
  end

  context 'with related array of array patterns' do
    context 'when using [*foo] to dynamically wrap only non-arrays in the list' do
      it 'does not register an offense since the map is doing useful work' do
        expect_no_offenses(<<~RUBY)
          [1, [2], 3].map { |id| [*id] }
        RUBY
      end
    end

    context 'when using Array.wrap the Rails extension of the [*foo] pattern that handles Hashes' do
      it 'does not register an offense since the map is doing useful work' do
        expect_no_offenses(<<~RUBY)
          [1, 2, 3].map { |id| Array.wrap(id) }
        RUBY
      end
    end

    context 'when making an array of arrays using each_with_object' do
      it 'does not register an offense since we have not included this pattern yet' do
        expect_no_offenses(<<~RUBY)
          [1,2,3].each_with_object([]) {|id, object| object << [id]}
        RUBY
      end
    end
  end

  context 'with a numblock', :ruby27 do
    context 'when using map with a numerical argument' do
      it 'registers an offense and corrects' do
        expect_offense(<<~RUBY)
          [1, 2, 3].map { [_1] }
                    ^^^^^^^^^^^^ Use `zip` without a block argument instead.
        RUBY

        expect_correction(<<~RUBY)
          [1, 2, 3].zip
        RUBY
      end
    end

    context 'when using map with a numblock in a chain' do
      it 'registers an offense and corrects' do
        expect_offense(<<~RUBY)
          [1, 2].sum.map { [_1] }.flatten
                     ^^^^^^^^^^^^ Use `zip` without a block argument instead.
        RUBY

        expect_correction(<<~RUBY)
          [1, 2].sum.zip.flatten
        RUBY
      end
    end

    context 'when using map on a range with a numblock' do
      it 'registers an offense and corrects' do
        expect_offense(<<~RUBY)
          (1..3).map { [_1] }
                 ^^^^^^^^^^^^ Use `zip` without a block argument instead.
        RUBY

        expect_correction(<<~RUBY)
          (1..3).zip
        RUBY
      end
    end

    context 'when using map in a do end block with a numblock' do
      it 'registers an offense and corrects' do
        expect_offense(<<~RUBY)
          (a..b).map do [_1] end
                 ^^^^^^^^^^^^^^^ Use `zip` without a block argument instead.
        RUBY

        expect_correction(<<~RUBY)
          (a..b).zip
        RUBY
      end
    end

    context 'when calling filter_map with a numblock' do
      it 'does not register an offense' do
        expect_no_offenses(<<~RUBY)
          [1, 2, 3].filter_map { [_1] }
        RUBY
      end
    end

    context 'when calling map, adding, and wrapping, with a numblock' do
      it 'does not register an offense' do
        expect_no_offenses(<<~RUBY)
          [1, 2, 3].map { [_1 + 1] }
        RUBY
      end
    end

    context 'when calling double wrapping with a numblock' do
      it 'does not register an offense' do
        expect_no_offenses(<<~RUBY)
          [1, 2, 3].map { [[_1]] }
        RUBY
      end
    end
  end

  context 'when calling map with an unused iterator' do
    it 'does not register an offense' do
      expect_no_offenses(<<~RUBY)
        [1, 2, 3].map { |e| [1] }
      RUBY
    end
  end

  context 'when calling map with a static block that always returns the same value' do
    it 'does not register an offense' do
      expect_no_offenses(<<~RUBY)
        [1, 2, 3].map { [id] }
      RUBY
    end
  end

  context 'when calling map with a static array' do
    it 'does not register an offense' do
      expect_no_offenses(<<~RUBY)
        [1, 2, 3].map { [] }
      RUBY
    end
  end

  context 'when map has no receiver' do
    it 'does not register an offense' do
      expect_no_offenses(<<~RUBY)
        map { |id| [id] }
      RUBY
    end
  end

  context 'when map has an indeterminate object as a receiver' do
    it 'still registers an offense' do
      expect_offense(<<~RUBY)
        foo.map { |id| [id] }
            ^^^^^^^^^^^^^^^^^ Use `zip` without a block argument instead.
      RUBY

      expect_correction(<<~RUBY)
        foo.zip
      RUBY
    end
  end
end
