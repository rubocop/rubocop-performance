# frozen_string_literal: true

module RuboCop
  module Cop
    module Performance
      # Identifies logical expressions where a cheaper operand
      # appears after a more expensive one (like a method call) in `and`/`&&` expressions.
      #
      # Reordering such expressions improves performance by leveraging Ruby's short-circuiting
      # behavior ensuring inexpensive checks are evaluated first.
      #
      # @example
      #   # bad
      #   costly_method? && local_var
      #
      #   # good
      #   local_var && costly_method?
      class ShortCircuitAnd < Base
        extend AutoCorrector

        MSG = 'Use short-circuit logic with cheaper expressions first to avoid unnecessary method calls.'

        def on_and(and_node)
          if and_node.children.first.and_type? && and_node.children[1].variable?
            handle_child_and(and_node)
          elsif !and_node.children.first.variable? && and_node.children[1].variable?
            handle_leaf(and_node)
          end
        end

        def handle_child_and(and_node)
          top_and_node = and_node
          var_node = and_node.children[1]
          loop do
            and_node = and_node.children.first
            unless and_node.children[1].variable?
              add_offense(top_and_node) do |corrector|
                corrector.swap(var_node, and_node.children[1])
              end
            end
            break unless and_node.children.first.and_type?
          end
        end

        def handle_leaf(and_node)
          add_offense(and_node) do |corrector|
            corrector.swap(and_node.children.first, and_node.children[1])
          end
        end
      end
    end
  end
end
