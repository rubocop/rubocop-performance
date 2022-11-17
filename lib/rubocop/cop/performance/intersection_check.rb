# frozen_string_literal: true

module RuboCop
  module Cop
    module Performance
      # In Ruby 3.1, `Array#intersect?` has been added.
      #
      # This cop identifies places where `(receiver & argument).any?`
      # can be replaced by `receiver.intersect?(argument)`.
      #
      # The `receiver.intersect?(argument)` method is faster than
      # `(receiver & argument).any?`.
      #
      # @example
      #   # bad
      #   (receiver & argument).present?
      #   (receiver & argument).any?
      #   (receiver & argument).blank?
      #   (receiver & argument).empty?
      #
      #   # good
      #   receiver.intersect?(argument)
      #   !receiver.intersect?(argument)
      class IntersectionCheck < Base
        extend AutoCorrector
        extend TargetRubyVersion

        minimum_target_ruby_version 3.1

        def_node_matcher :ampersand_intersection_check?, <<~PATTERN
          (send
            (begin 
              (send $(...) :& $(...))
            ) $/present?|any?|blank?|empty?/
          )
        PATTERN

        MSG = 'Use `%<negated>s%<receiver>s.intersect?(%<argument>s)` ' \
              'instead of `(%<receiver>s & %<argument>s).%<method_name>s`.'
        STRAIGHT_METHODS = %i[present? any?].freeze
        NEGATED_METHODS = %i[blank? empty?].freeze
        RESTRICT_ON_SEND = (STRAIGHT_METHODS + NEGATED_METHODS).freeze

        def on_send(node)
          return unless (receiver, argument, method_name = ampersand_intersection_check?(node))

          message = message(receiver.source, argument.source, method_name)

          add_offense(node, message: message) do |corrector|
            if straight?(method_name)
              corrector.replace(node, "#{receiver.source}.intersect?(#{argument.source})")
            else
              corrector.replace(node, "!#{receiver.source}.intersect?(#{argument.source})")
            end
          end
        end

        private

        def straight?(method_name)
          STRAIGHT_METHODS.include?(method_name.to_sym)
        end

        def message(receiver, argument, method_name)
          negated = straight?(method_name) ? '' : '!'
          format(MSG, negated: negated, receiver: receiver, argument: argument, method_name: method_name)
        end
      end
    end
  end
end
