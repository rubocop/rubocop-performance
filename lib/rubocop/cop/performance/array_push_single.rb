# frozen_string_literal: true

module RuboCop
  module Cop
    module Performance
      # Identifies places where pushing a single element to an array
      # can be replaced by `Array#<<`.
      #
      # @safety
      #   This cop is unsafe because not all objects that respond to `#push` also respond to `#<<`
      #
      # @example
      #   # bad
      #   array.push(1)
      #
      #   # good
      #   array << 1
      #
      #   # good
      #   array.push(1, 2, 3) # `<<` only works for one element
      #
      class ArrayPushSingle < Base
        extend AutoCorrector

        MSG = 'Use `<<` instead of `%<current>s`.'

        PUSH_METHODS = Set[:push, :append].freeze
        RESTRICT_ON_SEND = PUSH_METHODS

        def_node_matcher :push_call?, <<~PATTERN
          (call $_receiver $%PUSH_METHODS $!(splat _))
        PATTERN

        def on_send(node)
          push_call?(node) do |receiver, method_name, element|
            message = format(MSG, current: method_name)

            add_offense(node, message: message) do |corrector|
              corrector.replace(node, "#{receiver.source} << #{element.source}")
            end
          end
        end

        def on_csend(node)
          push_call?(node) do |receiver, method_name, element|
            message = format(MSG, current: method_name)

            add_offense(node, message: message) do |corrector|
              corrector.replace(node, "#{receiver.source}&.<< #{element.source}")
            end
          end
        end
      end
    end
  end
end
