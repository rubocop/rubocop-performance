# frozen_string_literal: true

module RuboCop
  module Cop
    module Performance
      # In Ruby 2.7, `Enumerable#filter_map` has been added.
      #
      # This cop identifies places where `map { ... }.compact` can be replaced by `filter_map`.
      # It is marked as unsafe auto-correction by default because `map { ... }.compact`
      # that is not compatible with `filter_map`.
      #
      # [source,ruby]
      # ----
      # [true, false, nil].compact              #=> [true, false]
      # [true, false, nil].filter_map(&:itself) #=> [true]
      # ----
      #
      # @example
      #   # bad
      #   ary.map(&:foo).compact
      #   ary.collect(&:foo).compact
      #
      #   # good
      #   ary.filter_map(&:foo)
      #   ary.map(&:foo).compact!
      #
      class MapCompact < Base
        include RangeHelp
        extend AutoCorrector
        extend TargetRubyVersion

        MSG = 'Use `filter_map` instead.'
        RESTRICT_ON_SEND = %i[compact].freeze

        minimum_target_ruby_version 2.7

        def_node_matcher :map_compact, <<~PATTERN
          {
            (send
              $(send _ {:map :collect}
                (block_pass
                  (sym _))) _)
            (send
              (block
                $(send _ {:map :collect})
                  (args ...) _) _)
          }
        PATTERN

        def on_send(node)
          return unless (map_node = map_compact(node))

          compact_loc = node.loc
          range = range_between(map_node.loc.selector.begin_pos, compact_loc.selector.end_pos)

          add_offense(range) do |corrector|
            corrector.replace(map_node.loc.selector, 'filter_map')
            corrector.remove(compact_loc.dot)
            corrector.remove(compact_loc.selector)
          end
        end
      end
    end
  end
end
