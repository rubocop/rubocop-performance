# frozen_string_literal: true

module RuboCop
  module Cop
    module Performance
      # This cop is used to identify usages of `reverse.each` (or
      # `reverse.each_with_index`) and change them to use
      # `reverse_each` (or `reverse_each.with_index`) instead.
      #
      # @example
      #   # bad
      #   [].reverse.each
      #   [].reverse.each_with_index
      #
      #   # good
      #   [].reverse_each
      #   [].reverse_each.with_index
      class ReverseEach < Base
        include RangeHelp
        extend AutoCorrector

        MSG = 'Use `reverse%<prefer_method>s` instead of `reverse.%<current_method>s`.'
        RESTRICT_ON_SEND = %i[each each_with_index].freeze

        def_node_matcher :reverse_each?, <<~MATCHER
          (send $(send _ :reverse) ${:each :each_with_index})
        MATCHER

        def on_send(node)
          reverse_each?(node) do |receiver, current_method|
            prefer_method = current_method == :each ? '_each' : '_each.with_index'
            message = format(MSG, current_method: current_method, prefer_method: prefer_method)

            register_offense(receiver, node, message, prefer_method)
          end
        end

        private

        def register_offense(receiver, node, msg, replacement)
          location_of_reverse = receiver.loc.selector.begin_pos
          end_location = node.loc.selector.end_pos

          range = range_between(location_of_reverse, end_location)

          add_offense(range, message: msg) do |corrector|
            corrector.replace(replacement_range(node), replacement)
          end
        end

        def replacement_range(node)
          range_between(node.loc.dot.begin_pos, node.loc.selector.end_pos)
        end
      end
    end
  end
end
