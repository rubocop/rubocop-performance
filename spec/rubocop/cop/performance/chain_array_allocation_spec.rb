# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Performance::ChainArrayAllocation, :config do
  subject(:cop) { described_class.new(config) }

  def generate_message(method_one, method_two)
    "Use unchained `#{method_one}!` and `#{method_two}!` "\
    '(followed by `return array` if required) instead of '\
    "chaining `#{method_one}...#{method_two}`."
  end

  shared_examples 'map_and_flat' do |method, method_two|
    it "registers an offense when calling #{method}...#{method_two}" do
      expect_offense(<<~RUBY, method: method, method_two: method_two)
        [1, 2, 3, 4].#{method} { |e| [e, e] }.#{method_two}
                     _{method}               ^^{method_two} #{generate_message(method, method_two)}
      RUBY
    end
  end

  describe 'configured to only warn when flattening one level' do
    it_behaves_like('map_and_flat', 'map', 'flatten')
  end

  describe 'Methods that require an argument' do
    it 'does not register an offense for `first.uniq`' do
      # Yes I know this is not valid Ruby
      expect_no_offenses(<<~RUBY)
        [1, 2, 3, 4].first.uniq
      RUBY
    end

    it 'registers an offense for `first(10).uniq`' do
      expect_offense(<<~RUBY)
        [1, 2, 3, 4].first(10).uniq
                              ^^^^^ Use unchained `first!` and `uniq!` (followed by `return array` if required) instead of chaining `first...uniq`.
      RUBY
    end

    it 'registers an offense for `first(variable).uniq`' do
      expect_offense(<<~RUBY)
        variable = 42
        [1, 2, 3, 4].first(variable).uniq
                                    ^^^^^ Use unchained `first!` and `uniq!` (followed by `return array` if required) instead of chaining `first...uniq`.
      RUBY
    end
  end

  describe 'methods that only return an array with no block' do
    it 'zip' do
      # Yes I know this is not valid Ruby
      expect_no_offenses(<<~RUBY)
        [1, 2, 3, 4].zip {|f| }.uniq
      RUBY

      expect_offense(<<~RUBY)
        [1, 2, 3, 4].zip {|f| }.zip.uniq
                                   ^^^^^ Use unchained `zip!` and `uniq!` (followed by `return array` if required) instead of chaining `zip...uniq`.
      RUBY
    end
  end
end
