# frozen_string_literal: true

module RuboCop
  module Cop
    module Performance
      # Identifies places where slicing arrays with semi-infinite ranges
      # can be replaced by `Array#take` and `Array#drop`.
      # This cop was created due to a mistake in microbenchmark and hence is disabled by default.
      # Refer https://github.com/rubocop/rubocop-performance/pull/175#issuecomment-731892717
      #
      # @safety
      #   This cop is unsafe for string slices because strings do not have `#take` and `#drop` methods.
      #
      # @example
      #   # bad
      #   array[..2]
      #   array[...2]
      #   array[2..]
      #   array[2...]
      #   array.slice(..2)
      #
      #   # good
      #   array.take(3)
      #   array.take(2)
      #   array.drop(2)
      #   array.drop(2)
      #   array.take(3)
      #
      class ArraySemiInfiniteRangeSlice < Base
        include RangeHelp
        extend AutoCorrector
        extend TargetRubyVersion

        minimum_target_ruby_version 2.7

        MSG = 'Use `%<prefer>s` instead of `%<current>s` with semi-infinite range.'

        SLICE_METHODS = Set[:[], :slice].freeze
        RESTRICT_ON_SEND = SLICE_METHODS

        def_node_matcher :endless_range_slice?, <<~PATTERN
          (call !any_str $%SLICE_METHODS $#endless_range?)
        PATTERN

        def_node_matcher :endless_range?, <<~PATTERN
          {
            (range nil? (int positive?))
            (range (int positive?) nil?)
          }
        PATTERN

        def on_send(node)
          endless_range_slice?(node) do |method_name, range_node|
            prefer = range_node.begin ? :drop : :take
            message = format(MSG, prefer: prefer, current: method_name)

            add_offense(node, message: message) do |corrector|
              # Replace only the slice call (everything after the receiver), so chained slices such as
              # `array.slice(1..).slice(2..)` do not produce overlapping corrections (Parser::ClobberingError).
              range = node.receiver.source_range.end.join(node.source_range.end)
              corrector.replace(range, ".#{correction(range_node)}")
            end
          end
        end
        alias on_csend on_send

        private

        def correction(range_node)
          if range_node.begin
            "drop(#{range_node.begin.value})"
          elsif range_node.irange_type?
            "take(#{range_node.end.value + 1})"
          else
            "take(#{range_node.end.value})"
          end
        end
      end
    end
  end
end
