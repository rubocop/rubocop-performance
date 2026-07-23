# frozen_string_literal: true

module RuboCop
  module Cop
    module Performance
      # Identifies places where `array.insert(0, item)` can be replaced with `array.unshift(item)`.
      #
      # The `unshift` method is specifically optimized for prepending elements to the beginning
      # of an array, providing up to 262x better performance than the more general `insert` method
      # when used at index 0.
      #
      # @example
      #   # bad
      #   array.insert(0, item)
      #   array.insert(0, 1, 2, 3)
      #   array.insert(0, *items)
      #
      #   # good
      #   array.unshift(item)
      #   array.unshift(1, 2, 3)
      #   array.unshift(*items)
      #
      #   # good - insert at other positions is fine
      #   array.insert(1, item)
      #   array.insert(-1, item)
      #   array.insert(index, item)
      #
      class ArrayInsert < Base
        include RangeHelp
        extend AutoCorrector

        MSG = 'Use `unshift` instead of `insert(0, ...)` for better performance.'
        RESTRICT_ON_SEND = %i[insert].freeze

        # @!method insert_at_zero?(node)
        def_node_matcher :insert_at_zero?, <<~PATTERN
          (send _ :insert (int 0) ...)
        PATTERN

        # rubocop:disable Metrics/AbcSize
        def on_send(node)
          return unless insert_at_zero?(node)

          add_offense(range_between(node.loc.selector.begin_pos, node.source_range.end_pos)) do |corrector|
            # Replace 'insert' with 'unshift'
            corrector.replace(node.loc.selector, 'unshift')

            # Remove the first argument (0) and its following comma/space
            first_arg = node.first_argument
            range_to_remove = if node.arguments.size > 1
                                second_arg = node.arguments[1]
                                # Remove from start of first arg to start of second arg
                                range_between(first_arg.source_range.begin_pos, second_arg.source_range.begin_pos)
                              elsif node.loc.begin && node.loc.end
                                # Edge case: only one argument with parentheses
                                range_between(node.loc.begin.begin_pos, node.loc.end.end_pos)
                              else
                                # No parentheses case
                                range_between(node.loc.selector.end_pos, first_arg.source_range.end_pos)
                              end
            corrector.remove(range_to_remove)
          end
        end
        # rubocop:enable Metrics/AbcSize
      end
    end
  end
end
