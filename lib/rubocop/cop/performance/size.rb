# frozen_string_literal: true

module RuboCop
  module Cop
    module Performance
      # This cop is used to identify usages of `count` on an
      # `Array` and `Hash` and change them to `size`.
      #
      # @example
      #   # bad
      #   [1, 2, 3].count
      #
      #   # bad
      #   {a: 1, b: 2, c: 3}.count
      #
      #   # good
      #   [1, 2, 3].size
      #
      #   # good
      #   {a: 1, b: 2, c: 3}.size
      #
      #   # good
      #   [1, 2, 3].count { |e| e > 2 }
      # TODO: Add advanced detection of variables that could
      # have been assigned to an array or a hash.
      class Size < Cop
        MSG = 'Use `size` instead of `count`.'

        def_node_matcher :array?, <<~PATTERN
          {
            [!nil? array_type?]
            (send _ :to_a)
            (send (const nil? :Array) :[] _)
          }
        PATTERN

        def_node_matcher :hash?, <<~PATTERN
          {
            [!nil? hash_type?]
            (send _ :to_h)
            (send (const nil? :Hash) :[] _)
          }
        PATTERN

        def_node_matcher :count?, <<~PATTERN
          (send {#array? #hash?} :count)
        PATTERN

        def on_send(node)
          return if node.parent&.block_type? || !count?(node)

          add_offense(node, location: :selector)
        end

        def autocorrect(node)
          ->(corrector) { corrector.replace(node.loc.selector, 'size') }
        end
      end
    end
  end
end
