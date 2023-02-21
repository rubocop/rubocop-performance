# frozen_string_literal: true

module RuboCop
  module Cop
    module Performance
      # Identifies usages of `any?`, `empty?` or `none?` predicate methods
      # chained to `select`/`filter` and change them to use predicate method instead.
      #
      # @example
      #   # bad
      #   arr.select { |x| x > 1 }.any?
      #
      #   # good
      #   arr.any? { |x| x > 1 }
      #
      #   # bad
      #   arr.select { |x| x > 1 }.empty?
      #   arr.select { |x| x > 1 }.none?
      #
      #   # good
      #   arr.none? { |x| x > 1 }
      #
      #   # good
      #   relation.select(:name).any?
      #   arr.select { |x| x > 1 }.any?(&:odd?)
      #
      class PredicateOnSelectResult < Base
        extend AutoCorrector

        MSG = 'Use `%<prefer>s` instead of `%<first_method>s.%<second_method>s`.'

        RESTRICT_ON_SEND = %i[any? empty? none?].freeze

        # @!method select_predicate?(node)
        def_node_matcher :select_predicate?, <<~PATTERN
          (send
            {
              (block $(send _ {:select :filter}) ...)
              $(send _ {:select :filter} block_pass_type?)
            }
            {:any? :empty? :none?})
        PATTERN

        REPLACEMENT_METHODS = { any?: :any?, empty?: :none?, none?: :none? }.freeze
        private_constant :REPLACEMENT_METHODS

        def on_send(node)
          return if node.arguments? || node.block_node

          select_predicate?(node) do |select_node|
            register_offense(select_node, node)
          end
        end

        private

        def register_offense(select_node, predicate_node)
          replacement = REPLACEMENT_METHODS[predicate_node.method_name]
          message = format(MSG, prefer: replacement,
                                first_method: select_node.method_name,
                                second_method: predicate_node.method_name)

          offense_range = offense_range(select_node, predicate_node)

          add_offense(offense_range, message: message) do |corrector|
            corrector.remove(predicate_range(predicate_node))
            corrector.replace(select_node.loc.selector, replacement)
          end
        end

        def offense_range(select_node, predicate_node)
          select_node.loc.selector.join(predicate_node.loc.selector)
        end

        def predicate_range(predicate_node)
          predicate_node.receiver.source_range.end.join(predicate_node.loc.selector)
        end
      end
    end
  end
end
