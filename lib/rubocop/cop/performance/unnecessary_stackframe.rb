# frozen_string_literal: true

module RuboCop
  module Cop
    module Performance
      # This cop identifies unnecessary use of a new block to forward the
      # received block when it could be forwarded.
      #
      # @example
      #   # bad
      #   def method
      #     do_something { yield }
      #   end
      #
      #   # good
      #   def method(&block)
      #     do_something(&block)
      #   end
      #
      class UnnecessaryStackframe < Base
        MSG = 'Forward the received block directly instead of using `yield`.'

        def_node_matcher :yield_in_block, <<~PATTERN
          (block (send ...) (args) (yield))
        PATTERN

        def on_block(node)
          yield_in_block(node) do |*args|
            add_offense(node)
          end
        end
      end
    end
  end
end
