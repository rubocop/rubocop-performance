# frozen_string_literal: true

module RuboCop
  module Cop
    module Performance
      # This cop identifies places where `split` argument can be replaced from
      # a deterministic regexp to a string.
      #
      # @example
      #   # bad
      #   'a,b,c'.split(/,/)
      #
      #   # good
      #   'a,b,c'.split(',')
      class RedundantSplitRegexpArgument < Base
        extend AutoCorrector

        MSG = 'Use string as argument instead of regexp.'
        RESTRICT_ON_SEND = %i[split].freeze
        DETERMINISTIC_REGEX = /\A(?:#{LITERAL_REGEX})+\Z/.freeze
        STR_SPECIAL_CHARS = %w[\n \" \' \\ \t \b \f \r].freeze

        def_node_matcher :split_call_with_regexp?, <<~PATTERN
          {(send !nil? :split {regexp})}
        PATTERN

        def on_send(node)
          return unless split_call_with_regexp?(node)
          return unless determinist_regexp?(node.first_argument)

          add_offense(node.first_argument) do |corrector|
            autocorrect(corrector, node)
          end
        end

        private

        def determinist_regexp?(first_argument)
          DETERMINISTIC_REGEX.match?(first_argument.source)
        end

        def autocorrect(corrector, node)
          new_argument = node.first_argument.source[1..-2]
          new_argument.delete!('\\') unless STR_SPECIAL_CHARS.include?(new_argument)

          corrector.replace(node.first_argument, "\"#{new_argument}\"")
        end
      end
    end
  end
end
