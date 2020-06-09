# frozen_string_literal: true

module RuboCop
  module Cop
    module Performance
      # This cop identifies places where `sort { |a, b| a <=> b }`
      # can be replaced with `sort`.
      #
      # @example
      #   # bad
      #   array.sort { |a, b| a <=> b }
      #
      #   # good
      #   array.sort
      #
      class RedundantSortBlock < Cop
        include SortBlock

        MSG = 'Use `sort` instead of `%<bad_method>s`.'

        def on_block(node)
          sort_with_block?(node) do |send, var_a, var_b, body|
            replaceable_body?(body, var_a, var_b) do
              range = sort_range(send, node)

              add_offense(
                node,
                location: range,
                message: message(var_a, var_b)
              )
            end
          end
        end

        def autocorrect(node)
          sort_with_block?(node) do |send, _var_a, _var_b, _body|
            lambda do |corrector|
              range = sort_range(send, node)
              corrector.replace(range, 'sort')
            end
          end
        end

        private

        def message(var_a, var_b)
          bad_method = "sort { |#{var_a}, #{var_b}| #{var_a} <=> #{var_b} }"
          format(MSG, bad_method: bad_method)
        end
      end
    end
  end
end
