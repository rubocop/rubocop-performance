# frozen_string_literal: true

module RuboCop
  module Cop
    module Performance
      # Identifies usages of `array.compact.flatten.map { |x| x.downcase }`.
      # Each of these methods (`compact`, `flatten`, `map`) will generate a new intermediate array
      # that is promptly thrown away. Instead it is faster to mutate when we know it's safe.
      #
      # @safety
      #   This cop is unsafe because it cannot determine whether a method returns
      #   a fresh, mutable array that is not retained elsewhere. An overridden
      #   method may return a shared or frozen array, even when its name matches
      #   an Array method. Mutating that result can change observable state or raise
      #   `FrozenError`. Verify ownership before applying the suggestion, and do
      #   not mutate the original receiver merely to avoid intermediate arrays.
      #
      # @example
      #   # bad
      #   array = ["a", "b", "c"]
      #   array.compact.flatten.map { |x| x.downcase }
      #
      #   # good - the standard Array#compact returns an unshared, mutable array here
      #   array = ["a", "b", "c"]
      #   array = array.compact
      #   array.flatten!
      #   array.map! { |x| x.downcase }
      #   array
      #
      # @example Unsafe when an overridden method retains the intermediate array
      #   class RetainingArray < Array
      #     attr_reader :unique
      #
      #     def uniq
      #       @unique = super
      #     end
      #   end
      #
      #   values = RetainingArray.new([1, 1, 2])
      #   values.uniq.map { |n| n * 2 }
      #   values.unique # => [1, 2]
      #   values.uniq.map! { |n| n * 2 }
      #   values.unique # => [2, 4]
      class ChainArrayAllocation < Base
        # These methods return a new array but only sometimes. They must be
        # called with an argument. For example:
        #
        #   [1,2].first    # => 1
        #   [1,2].first(1) # => [1]
        #
        RETURN_NEW_ARRAY_WHEN_ARGS = %i[first last pop sample shift].to_set.freeze

        # These methods return a new array only when called without a block.
        RETURNS_NEW_ARRAY_WHEN_NO_BLOCK = %i[zip product].to_set.freeze

        # The standard Array implementations return new arrays. Overrides may
        # retain or freeze their results, so their ownership still needs review.
        ALWAYS_RETURNS_NEW_ARRAY = %i[* + - collect collect_concat compact drop
                                      drop_while filter_map flat_map flatten map
                                      reject reverse rotate select shuffle sort
                                      take take_while transpose uniq
                                      values_at |].to_set.freeze

        # These methods have a mutation alternative. For example :collect
        # can be called as :collect!
        HAS_MUTATION_ALTERNATIVE = %i[collect compact flatten map reject
                                      reverse rotate select shuffle sort uniq].to_set.freeze

        RETURNS_NEW_ARRAY = (ALWAYS_RETURNS_NEW_ARRAY + RETURNS_NEW_ARRAY_WHEN_NO_BLOCK).freeze

        RESTRICT_ON_SEND = RETURNS_NEW_ARRAY

        MSG = 'Use unchained `%<method>s` and `%<second_method>s!` ' \
              '(followed by `return array` if required) instead of chaining ' \
              '`%<method>s...%<second_method>s`.'

        def_node_matcher :chain_array_allocation?, <<~PATTERN
          (send {
            (send _ $%RETURN_NEW_ARRAY_WHEN_ARGS {int lvar ivar cvar gvar send})
            (any_block (send _ $%ALWAYS_RETURNS_NEW_ARRAY) ...)
            (send _ $%RETURNS_NEW_ARRAY ...)
          } $%HAS_MUTATION_ALTERNATIVE ...)
        PATTERN

        def on_send(node)
          chain_array_allocation?(node) do |fm, sm|
            return if node.each_descendant(:send).any? { |descendant| descendant.method?(:lazy) }
            return if node.method?(:select) && !enumerable_select_method?(node.receiver)

            range = node.loc.selector.begin.join(node.source_range.end)

            add_offense(range, message: format(MSG, method: fm, second_method: sm))
          end
        end

        private

        def enumerable_select_method?(node)
          # NOTE: `QueryMethods#select` in Rails accepts positional arguments, whereas `Enumerable#select` does not.
          #        This difference can be utilized to reduce the knowledge requirements related to `select`.
          node.any_block_type? && node.send_node.arguments.empty?
        end
      end
    end
  end
end
