# frozen_string_literal: true

module RuboCop
  module Cop
    module Performance
      # Identifies chained `merge` calls that can be replaced with a single
      # multi-argument call.
      #
      # Every call in the chain allocates an intermediate hash, while `Hash#merge`
      # accepts multiple arguments since Ruby 2.6.
      #
      # Chains in which any call takes a block are ignored, because the block is
      # only applied to the conflicts of the call it is attached to.
      #
      # @safety
      #   This cop is unsafe because the receiver may not be a `Hash`, and a `merge`
      #   method of another class may not accept multiple arguments. For example,
      #   `ActiveRecord::Relation#merge` accepts a single argument.
      #
      # @example
      #
      #   # bad
      #   hash.merge(a).merge(b)
      #   hash.merge(a).merge(b).merge(c)
      #
      #   # good
      #   hash.merge(a, b)
      #   hash.merge(a, b, c)
      #
      class ChainedHashMerge < Base
        include IgnoredNode
        extend AutoCorrector
        extend TargetRubyVersion

        minimum_target_ruby_version 2.6

        MSG = 'Use `%<replacement>s` instead of chained `merge` calls.'
        RESTRICT_ON_SEND = %i[merge].freeze

        def on_send(node)
          return if part_of_ignored_node?(node)
          return unless (chain = merge_chain(node))

          replacement = replacement(chain)
          range = chain.first.loc.selector.join(node.source_range.end)

          message = format(MSG, replacement: replacement)

          add_offense(range, message: message) do |corrector|
            corrector.replace(range, replacement)
          end

          ignore_node(node)
        end
        alias on_csend on_send

        private

        def merge_chain(node)
          return unless collapsible?(node)

          chain = [node]

          while (receiver = chain.first.receiver)
            break unless receiver.call_type? && receiver.method?(:merge) && collapsible?(receiver)

            chain.unshift(receiver)
          end

          chain if chain.size > 1
        end

        def collapsible?(node)
          return false if node.block_literal? || node.arguments.empty?

          node.arguments.none? { |argument| argument.block_pass_type? || heredoc?(argument) }
        end

        def heredoc?(node)
          node.each_node(:any_str).any?(&:heredoc?)
        end

        def replacement(chain)
          arguments = chain.flat_map(&:arguments)
          sources = arguments.map.with_index do |argument, index|
            if argument.hash_type? && !argument.braces? && index != arguments.size - 1
              "{ #{argument.source} }"
            else
              argument.source
            end
          end

          "merge(#{sources.join(', ')})"
        end
      end
    end
  end
end
