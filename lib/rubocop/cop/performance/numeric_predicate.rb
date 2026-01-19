# frozen_string_literal: true

module RuboCop
  module Cop
    module Performance
      # Identifies places where numeric uses predicates `positive?`, and `negative?` should be
      # converted to compare operator.
      #
      # @safety
      #   This cop is unsafe because it cannot be guaranteed that the receiver
      #   defines the predicates or can be compared to a number, which may lead
      #   to a false positive for non-standard classes.
      #
      # @example
      #   # bad
      #   1.positive?
      #   1.43.negative?
      #   -4.zero?
      #
      #   # good
      #   1 > 0
      #   1.43 < 0.0
      #   -4 == 0
      #
      class NumericPredicate < Base
        extend AutoCorrector

        MSG = 'Use compare operator `%<good>s` instead of `%<bad>s`.'
        RESTRICT_ON_SEND = %i[positive? zero? negative?].freeze
        REPLACEMENTS = { negative?: '<', positive?: '>', zero?: '==' }.freeze

        def_node_matcher :num_predicate?, <<~PATTERN
          (send $numeric_type? ${:negative? :positive? :zero?})
        PATTERN

        def_node_matcher :instance_predicate?, <<~PATTERN
          (send $!nil? ${:negative? :positive?})
        PATTERN

        def on_send(node)
          return unless num_predicate?(node) || instance_predicate?(node)
          return unless node.receiver

          good_method = build_good_method(node.receiver, node.method_name)
          message = format(MSG, good: good_method, bad: node.source)
          add_offense(node, message: message) do |corrector|
            corrector.replace(node, good_method)
          end
        end

        private

        def build_good_method(receiver, method)
          operation = REPLACEMENTS[method]
          zero = receiver&.float_type? ? 0.0 : 0
          "#{receiver.source} #{operation} #{zero}"
        end
      end
    end
  end
end
