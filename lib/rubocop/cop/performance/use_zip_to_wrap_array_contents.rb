# frozen_string_literal: true

module RuboCop
  module Cop
    module Performance
      # Checks for `.map { |id| [id] }` and suggests replacing it with `.zip`.
      #
      # @example
      #   # bad
      #   [1, 2, 3].map { |id| [id] }
      #
      #   # good
      #   [1, 2, 3].zip
      #
      # @example
      #   # good (no offense)
      #   [1, 2, 3].map { |id| id }
      #
      # @example
      #   # good (no offense)
      #   [1, 2, 3].map { |id| [id, id] }
      class UseZipToWrapArrayContents < Base
        include RangeHelp
        extend AutoCorrector

        MSG = 'Use `.zip` instead of `.map { |id| [id] }`.'
        RESTRICT_ON_SEND = %i[map].freeze

        # Matches regular block form `.map { |e| [e] }`
        # @!method map_with_array?(node)
        def_node_matcher :map_with_array?, <<~PATTERN
          (block
            (send _ :map)
            (args (arg _id))
            (array (lvar _id)))
        PATTERN

        # Matches numblock form `.map { [_1] }`
        # @!method map_with_array_numblock?(node)
        def_node_matcher :map_with_array_numblock?, <<~PATTERN
          (numblock
            (send _ :map)
            1
            (array (lvar _))
          )
        PATTERN

        def on_send(node)
          return unless (parent = node.parent)
          return unless map_with_array?(parent) || map_with_array_numblock?(parent)
          return unless (receiver = node.receiver&.source)

          register_offense(parent, receiver)
        end

        private

        def register_offense(parent, receiver)
          add_offense(offense_range(parent)) do |corrector|
            autocorrect(parent, receiver, corrector)
          end
        end

        def autocorrect(parent, receiver, corrector)
          corrector.replace(parent, "#{receiver}.zip")
        end

        def offense_range(node)
          range_between(node.children.first.loc.selector.begin_pos, node.loc.end.end_pos)
        end
      end
    end
  end
end
