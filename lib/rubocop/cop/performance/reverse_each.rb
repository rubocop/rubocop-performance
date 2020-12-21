# frozen_string_literal: true

module RuboCop
  module Cop
    module Performance
      # This cop is used to identify usages of `reverse.each` and
      # change them to use `reverse_each` instead.
      #
      # @example
      #   # bad
      #   [].reverse.each
      #
      #   # good
      #   [].reverse_each
      class ReverseEach < Base
        include RangeHelp
        extend AutoCorrector

        MSG = 'Use `reverse_each` instead of `reverse.each`.'
        RESTRICT_ON_SEND = %i[each].freeze

        def_node_matcher :reverse_each?, <<~MATCHER
          (send (send _ :reverse) :each)
        MATCHER

        def on_send(node)
          reverse_each?(node) do
            range = offense_range(node)

            add_offense(range) do |corrector|
              corrector.replace(range, 'reverse_each')
            end
          end
        end

        private

        def offense_range(node)
          range_between(node.children.first.loc.selector.begin_pos, node.loc.selector.end_pos)
        end
      end
    end
  end
end
