# frozen_string_literal: true

module RuboCop
  module Cop
    module Performance
      # Identifies places where concatinating a literal to an array
      # can be replaced by pushing its elements directly.
      #
      # @safety
      #   This cop is unsafe because not all objects that respond to `#concat` also respond to `#push`
      #
      # @example
      #   # bad
      #   array.concat([1, 2, 3])
      #
      #   # good
      #   array.push(1, 2, 3)
      #
      #   # good
      #   array.concat(not_a_literal)
      #
      class ArrayConcatLiteral < Base
        extend AutoCorrector

        MSG = 'Use `push` instead of concatinating a literal.'

        RESTRICT_ON_SEND = %i[concat].freeze

        def_node_matcher :concat_call?, <<~PATTERN
          (call $_receiver :concat $(array ...))
        PATTERN

        def on_send(node)
          concat_call?(node) do |receiver, elements|
            add_offense(node) do |corrector|
              corrector.replace(node, "#{receiver.source}.push(#{remove_brackets(elements)})")
            end
          end
        end

        def on_csend(node)
          concat_call?(node) do |receiver, elements|
            add_offense(node) do |corrector|
              corrector.replace(node, "#{receiver.source}&.push(#{remove_brackets(elements)})")
            end
          end
        end

        private

        # Copied from `Lint/RedundantSplatExpansion`
        # TODO: Expose this as a helper API from the base RuboCop gem
        PERCENT_W = '%w'
        PERCENT_CAPITAL_W = '%W'
        PERCENT_I = '%i'
        PERCENT_CAPITAL_I = '%I'

        def remove_brackets(array)
          array_start = array.loc.begin.source
          elements = *array
          elements = elements.map(&:source)

          if array_start.start_with?(PERCENT_W)
            "'#{elements.join("', '")}'"
          elsif array_start.start_with?(PERCENT_CAPITAL_W)
            %("#{elements.join('", "')}")
          elsif array_start.start_with?(PERCENT_I)
            ":#{elements.join(', :')}"
          elsif array_start.start_with?(PERCENT_CAPITAL_I)
            %(:"#{elements.join('", :"')}")
          else
            elements.join(', ')
          end
        end
      end
    end
  end
end
