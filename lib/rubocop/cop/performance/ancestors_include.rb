# frozen_string_literal: true

module RuboCop
  module Cop
    module Performance
      # This cop is used to identify usages of `ancestors.include?` and
      # change them to use `<=` instead.
      #
      # @example
      #   # bad
      #   A.ancestors.include?(B)
      #
      #   # good
      #   A <= B
      #
      class AncestorsInclude < Cop
        include RangeHelp

        MSG = 'Use `<=` instead of `ancestors.include?`.'

        def_node_matcher :ancestors_include_candidate?, <<~PATTERN
          (send (send $_subclass :ancestors) :include? $_superclass)
        PATTERN

        def on_send(node)
          return unless ancestors_include_candidate?(node)

          location_of_ancestors = node.children[0].loc.selector.begin_pos
          end_location = node.loc.selector.end_pos
          range = range_between(location_of_ancestors, end_location)

          add_offense(node, location: range)
        end

        def autocorrect(node)
          ancestors_include_candidate?(node) do |subclass, superclass|
            lambda do |corrector|
              corrector.replace(node, "#{subclass.source} <= #{superclass.source}")
            end
          end
        end
      end
    end
  end
end
