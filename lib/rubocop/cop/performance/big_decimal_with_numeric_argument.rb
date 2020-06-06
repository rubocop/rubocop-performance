# frozen_string_literal: true

module RuboCop
  module Cop
    module Performance
      # This cop identifies places where numeric argument to BigDecimal should be
      # converted to string. Initializing from String is faster
      # than from Numeric for BigDecimal.
      #
      # @example
      #
      #   # bad
      # BigDecimal(1, 2)
      # BigDecimal(1.2, 3, exception: true)
      #
      #   # good
      # BigDecimal('1', 2)
      # BigDecimal('1.2', 3, exception: true)
      #
      class BigDecimalWithNumericArgument < Cop
        MSG = 'Convert numeric argument to string before passing to `BigDecimal`.'

        def_node_matcher :big_decimal_with_numeric_argument?, <<~PATTERN
          (send nil? :BigDecimal $numeric_type? ...)
        PATTERN

        def on_send(node)
          big_decimal_with_numeric_argument?(node) do |numeric|
            add_offense(node, location: numeric.source_range)
          end
        end

        def autocorrect(node)
          big_decimal_with_numeric_argument?(node) do |numeric|
            lambda do |corrector|
              corrector.wrap(numeric, "'", "'")
            end
          end
        end
      end
    end
  end
end
