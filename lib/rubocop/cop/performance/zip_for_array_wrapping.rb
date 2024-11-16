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
      #   # bad
      #   [1, 2, 3].map { [_1] }
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
      class ZipForArrayWrapping < Base
        include RangeHelp
        extend AutoCorrector

        MSG = 'Use `zip` instead of `%<original_code>s`.'
        RESTRICT_ON_SEND = Set.new(%i[map collect]).freeze

        # Matches regular block form `.map { |e| [e] }`
        # @!method map_with_array?(node)
        def_node_matcher :map_with_array?, <<~PATTERN
          (block
            (send _ RESTRICT_ON_SEND)
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

          register_offense(parent, receiver, node)
        end

        private

        def register_offense(parent, receiver, node)
          add_offense(offense_range(parent), message: message(node)) do |corrector|
            autocorrect(parent, receiver, corrector)
          end
        end

        def message(node)
          format(MSG, original_code: offense_range(node).source.lines.first.chomp)
        end

        def autocorrect(parent, receiver, corrector)
          corrector.replace(parent, "#{receiver}.zip")
        end

        def offense_range(node)
          @offense_range ||= range_between(node.children.first.loc.selector.begin_pos, node.loc.end.end_pos)
        end
      end
    end
  end
end
