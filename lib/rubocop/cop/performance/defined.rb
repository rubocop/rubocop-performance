# frozen_string_literal: true

module RuboCop
  module Cop
    module Performance
      # Identifies usages of `class_variable_defined?`, `const_defined?`,
      # `instance_variable_defined?` that can be replaced with `defined?`.
      #
      # @example
      #   # bad
      #   return if class_variable_defined?(:@@foo)
      #   return if const_defined?(:Foo)
      #   return if const_defined?(:Foo)
      #   return if instance_variable_defined?(:@foo)
      #
      #   # good
      #   return if defined?(@@foo)
      #   return if defined?(Foo)
      #   return if defined?(@foo)
      #
      #   # good (explicit receiver)
      #   obj.instance_variable_defined?(:@foo)
      #
      #   # good (non basic literal expression)
      #   obj.instance_variable_defined?(ivar_name)
      #
      #   # good (`const_defined?` disallowing inheritance)
      #   const_defined?(:Foo, false)
      #   const_defined?(:Foo, inherit)
      #
      #   # bad (as a non condition)
      #   instance_variable_defined?(:@foo)
      #
      #   # good
      #   !defined(@foo).nil?
      #
      class Defined < Base
        extend AutoCorrector

        MSG = 'Use `defined?` instead of `%<bad_method>s`.'

        RESTRICT_ON_SEND = %i[class_variable_defined? const_defined? instance_variable_defined?].freeze

        def_node_matcher :defined_candidate?, <<~PATTERN
          (send nil? ${:#{RESTRICT_ON_SEND.join(' :')}} $#basic_literal? (true) ?)
        PATTERN

        def on_send(node)
          defined_candidate?(node) do |method_name, expression_node|
            message = format(MSG, bad_method: method_name)
            add_offense(node.loc.selector, message: message) do |corrector|
              replacement = "defined?(#{expression_node.value})"
              replacement = "!#{replacement}.nil?" unless condition?(node)
              corrector.replace(node, replacement)
            end
          end
        end

        private

        def basic_literal?(node)
          node&.basic_literal?
        end

        def condition?(node)
          return false unless (parent = non_begin_parent(node))

          (parent.basic_conditional? && parent.condition == node) ||
            (parent.or_type? || parent.and_type?)
        end

        def non_begin_parent(node)
          parent = node.parent
          parent = parent.parent while parent&.begin_type?
          parent
        end
      end
    end
  end
end
