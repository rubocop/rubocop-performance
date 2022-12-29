# frozen_string_literal: true

module RuboCop
  module Cop
    module Performance
      # Detects use of `Enumerable#reduce` and `Hash#merge` together, which
      # should be avoided as it needlessly copies the hash on each iteration.
      # Using `Hash#merge!` with `reduce` is acceptable, although it is better
      # to use `Enumerable#each_with_object` to mutate the `Hash` directly.
      #
      # @safety
      #   This cop is unsafe because it cannot know if the outer method being
      #   called is actually `Enumerable#reduce` or if the inner method is
      #   `Hash#merge`.
      #
      #   # bad
      #   [[:key, :value]].reduce({}) do |hash, (key, value)|
      #     hash.merge(key => value)
      #   end
      #
      #   # bad
      #   [{ key: :value }].reduce({}) do |hash, element|
      #     hash.merge(element)
      #   end
      #
      #   # bad
      #   [object].reduce({}) do |hash, element|
      #     key, value = element.something
      #     hash.merge(key => value)
      #   end
      #
      #   # okay
      #   [[:key, :value]].reduce({}) do |hash, (key, value)|
      #     hash.merge!(key => value)
      #   end
      #
      #   # good
      #   [[:key, :value]].each_with_object({}) do |(key, value), hash|
      #     hash[key] = value
      #   end
      #
      #   # good
      #   [{ key: :value }].each_with_object({}) do |element, hash|
      #     hash.merge!(element)
      #   end
      #
      #   # good
      #   [object].each_with_object({}) do |element, hash|
      #     key, value = element.something
      #     hash[key] = value
      #   end
      #
      class ReduceMerge < Base
        extend AutoCorrector

        MSG = 'Do not use `Hash#merge` to build new hashes within `Enumerable#reduce`. ' \
              'Use `Enumerable#each_with_object({})` and mutate a single `Hash` instead.`'

        # @!method reduce_with_merge(node)
        def_node_matcher :reduce_with_merge, <<~PATTERN
          (block
            $(send _ :reduce ...)
            $(args (arg $_) ...) 
            {
              (begin
                ...
                $(send (lvar $_) :merge ...)
              )

              $(send (lvar $_) :merge ...)
            }
          )
        PATTERN

        def on_block(node)
          reduce_with_merge(node) do |reduce_send, block_args, first_block_arg, merge_send, merge_receiver|
            return unless first_block_arg == merge_receiver

            add_offense(node) do |corrector|
              replace_method_name(corrector, reduce_send, 'each_with_object')

              # reduce passes previous element first; each_with_object passes memo object last
              rotate_block_arguments(corrector, block_args)

              replace_merge(corrector, merge_send)
            end
          end
        end

        private

        def replace_method_name(corrector, send_node, new_method_name)
          corrector.replace(send_node.loc.selector, new_method_name)
        end

        def rotate_block_arguments(corrector, args_node, by: 1)
          corrector.replace(
            args_node.source_range,
            "|#{args_node.each_child_node.map(&:source).rotate!(by).join(', ')}|"
          )
        end

        def replace_merge(corrector, merge_send_node)
          receiver = merge_send_node.receiver.source
          indentation = merge_send_node.source_range.source_line[/^\s+/]
          replacement = merge_send_node
                        .arguments
                        .chunk(&:hash_type?)
                        .flat_map { |are_hash_type, args| replacements_for_args(receiver, args, are_hash_type) }
                        .join("\n#{indentation}")

          corrector.replace(merge_send_node.source_range, replacement)
        end

        def replacements_for_args(receiver, arguments, arguments_are_hash_literals)
          if arguments_are_hash_literals
            replacements_for_hash_literals(receiver, arguments)
          else
            replacement_for_other_arguments(receiver, arguments)
          end
        end

        def replacements_for_hash_literals(receiver, hash_literals)
          hash_literals.flat_map do |hash|
            hash.pairs.map do |pair|
              "#{receiver}[#{pair.key.source}] = #{pair.value.source}"
            end
          end
        end

        def replacement_for_other_arguments(receiver, arguments)
          "#{receiver}.merge!(#{arguments.map(&:source).join(', ')})"
        end
      end
    end
  end
end
