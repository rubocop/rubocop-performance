# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Performance::FlatMap, :config do
  shared_examples 'map_and_collect' do |method, flatten|
    it "registers an offense and corrects when calling #{method}...#{flatten}(1)" do
      expect_offense(<<~RUBY, method: method, flatten: flatten)
        [1, 2, 3, 4].#{method} { |e| [e, e] }.#{flatten}(1)
                     ^{method}^^^^^^^^^^^^^^^^^{flatten}^^^ Use `flat_map` instead of `#{method}...#{flatten}`.
      RUBY

      expect_correction(<<~RUBY)
        [1, 2, 3, 4].flat_map { |e| [e, e] }
      RUBY
    end

    it "registers an offense and corrects when calling #{method}(&:foo).#{flatten}(1)" do
      expect_offense(<<~RUBY, method: method, flatten: flatten)
        [1, 2, 3, 4].#{method}(&:foo).#{flatten}(1)
                     ^{method}^^^^^^^^^{flatten}^^^ Use `flat_map` instead of `#{method}...#{flatten}`.
      RUBY

      expect_correction(<<~RUBY)
        [1, 2, 3, 4].flat_map(&:foo)
      RUBY
    end

    it "registers an offense and corrects when calling #{method}(&foo).#{flatten}(1)" do
      expect_offense(<<~RUBY, method: method, flatten: flatten)
        [1, 2, 3, 4].#{method}(&foo).#{flatten}(1)
                     ^{method}^^^^^^^^{flatten}^^^ Use `flat_map` instead of `#{method}...#{flatten}`.
      RUBY

      expect_correction(<<~RUBY)
        [1, 2, 3, 4].flat_map(&foo)
      RUBY
    end

    it "does not register an offense when calling #{method}...#{flatten} with a number greater than 1" do
      expect_no_offenses("[1, 2, 3, 4].#{method} { |e| [e, e] }.#{flatten}(3)")
    end

    it "does not register an offense when calling #{method}!...#{flatten}" do
      expect_no_offenses("[1, 2, 3, 4].#{method}! { |e| [e, e] }.#{flatten}")
    end
  end

  describe 'configured to only warn when flattening one level' do
    let(:config) do
      RuboCop::Config.new('Performance/FlatMap' => { 'Enabled' => true, 'EnabledForFlattenWithoutParams' => false })
    end

    shared_examples 'flatten_with_params_disabled' do |method, flatten|
      it "does not register an offense when calling #{method}...#{flatten}" do
        expect_no_offenses("[1, 2, 3, 4].map { |e| [e, e] }.#{flatten}")
      end
    end

    it_behaves_like('map_and_collect', 'map', 'flatten')
    it_behaves_like('map_and_collect', 'map', 'flatten!')
    it_behaves_like('map_and_collect', 'collect', 'flatten')
    it_behaves_like('map_and_collect', 'collect', 'flatten!')

    it_behaves_like('flatten_with_params_disabled', 'map', 'flatten')
    it_behaves_like('flatten_with_params_disabled', 'collect', 'flatten')
    it_behaves_like('flatten_with_params_disabled', 'map', 'flatten!')
    it_behaves_like('flatten_with_params_disabled', 'collect', 'flatten!')
  end

  describe 'configured to warn when flatten is not called with parameters' do
    let(:config) do
      RuboCop::Config.new('Performance/FlatMap' => { 'Enabled' => true, 'EnabledForFlattenWithoutParams' => true })
    end

    shared_examples 'flatten_with_params_enabled' do |method, flatten|
      it "registers an offense when calling #{method}...#{flatten}" do
        expect_offense(<<~RUBY, method: method, flatten: flatten)
          [1, 2, 3, 4].#{method} { |e| [e, e] }.#{flatten}
                       ^{method}^^^^^^^^^^^^^^^^^{flatten} Use `flat_map` instead of `#{method}...#{flatten}`. Beware, `flat_map` only flattens 1 level and `flatten` can be used to flatten multiple levels.
        RUBY

        expect_no_corrections
      end
    end

    it_behaves_like('map_and_collect', 'map', 'flatten')
    it_behaves_like('map_and_collect', 'map', 'flatten!')
    it_behaves_like('map_and_collect', 'collect', 'flatten')
    it_behaves_like('map_and_collect', 'collect', 'flatten!')

    it_behaves_like('flatten_with_params_enabled', 'map', 'flatten')
    it_behaves_like('flatten_with_params_enabled', 'collect', 'flatten')
    it_behaves_like('flatten_with_params_enabled', 'map', 'flatten!')
    it_behaves_like('flatten_with_params_enabled', 'collect', 'flatten!')
  end
end
