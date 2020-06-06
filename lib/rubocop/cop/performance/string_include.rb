# frozen_string_literal: true

module RuboCop
  module Cop
    module Performance
      # This cop identifies unnecessary use of a regex where
      # `String#include?` would suffice.
      #
      # @example
      #   # bad
      #   'abc'.match?(/ab/)
      #   /ab/.match?('abc')
      #   'abc' =~ /ab/
      #   /ab/ =~ 'abc'
      #   'abc'.match(/ab/)
      #   /ab/.match('abc')
      #
      #   # good
      #   'abc'.include?('ab')
      class StringInclude < Cop
        MSG = 'Use `String#include?` instead of a regex match with literal-only pattern.'

        def_node_matcher :redundant_regex?, <<~PATTERN
          {(send $!nil? {:match :=~ :match?} (regexp (str $#literal?) (regopt)))
           (send (regexp (str $#literal?) (regopt)) {:match :match?} $_)
           (match-with-lvasgn (regexp (str $#literal?) (regopt)) $_)}
        PATTERN

        def on_send(node)
          return unless redundant_regex?(node)

          add_offense(node)
        end
        alias on_match_with_lvasgn on_send

        def autocorrect(node)
          redundant_regex?(node) do |receiver, regex_str|
            receiver, regex_str = regex_str, receiver if receiver.is_a?(String)
            regex_str = interpret_string_escapes(regex_str)

            lambda do |corrector|
              new_source = receiver.source + '.include?(' +
                           to_string_literal(regex_str) + ')'
              corrector.replace(node.source_range, new_source)
            end
          end
        end

        private

        def literal?(regex_str)
          regex_str.match?(/\A#{Util::LITERAL_REGEX}+\z/)
        end
      end
    end
  end
end
