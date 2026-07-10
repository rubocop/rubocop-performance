# frozen_string_literal: true

module RuboCop
  module Cop
    module Performance
      # Move conditional logic outside of the method body definition to
      # improve performance by avoiding repeated evaluation of constant condition.
      #
      # @example
      #   # bad
      #   def answer
      #     if RUBY_VERSION < '4.0.'
      #       42
      #     else
      #       239
      #     end
      #   end
      #
      #   # good
      #   if RUBY_VERSION < '4.0.'
      #     def answer
      #       42
      #     end
      #   else
      #     def answer
      #       239
      #     end
      #   end
      class ConditionalDefinition < Base
        MSG = 'Move conditional logic outside of the method body definition to ' \
              'improve performance by avoiding repeated evaluation of constant condition.'

        CONSTANTS = Set[
          :RUBY_VERSION,
          :RUBY_RELEASE_DATE,
          :RUBY_PLATFORM,
          :RUBY_PATCHLEVEL,
          :RUBY_REVISION,
          :RUBY_COPYRIGHT,
          :RUBY_ENGINE,
          :RUBY_ENGINE_VERSION,
          :RUBY_DESCRIPTION
        ].freeze
        OPERATORS = Set[:<, :<=, :==, :>=, :>, :=~, :===].freeze
        private_constant :CONSTANTS, :OPERATORS

        def on_def(node)
          return unless dynamic_definition_in_body?(node)

          dynamic_definition_in_body?(node) do
            add_offense(node)
          end
        end

        # @!method bad_method?(node)
        def_node_matcher :dynamic_definition_in_body?, <<~PATTERN
          (def _ (...)
            (if
              {
                (send (const nil? CONSTANTS) OPERATORS _)
                (send _ OPERATORS (const nil? CONSTANTS))
              }
              _ _))
        PATTERN
      end
    end
  end
end
