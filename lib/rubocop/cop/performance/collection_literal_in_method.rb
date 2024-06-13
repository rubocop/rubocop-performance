# frozen_string_literal: true

module RuboCop
  module Cop
    module Performance
      # Identifies places where Array and Hash literals are used within method.
      # It is better to extract them into a constant to avoid unnecessary allocations
      # on each iteration.
      #
      # You can set the minimum number of elements to consider
      # an offense with `MinSize`.
      #
      # @example
      #   # bad
      #   def fallback_data(config)
      #     {
      #       foo: 'bar',
      #       sit: 'amet',
      #     }.merge(config)
      #   end
      #
      #   # good
      #   FALLBACK_DATA = {
      #     foo: 'bar',
      #     sit: 'amet',
      #   }.freeze
      #
      #   def fallback_data(config)
      #     FALLBACK_DATA.merge(config)
      #   end
      #
      class CollectionLiteralInMethod < Base
        MSG = 'Avoid immutable %<literal_class>s literals in method definition. ' \
              'It is better to extract it into a constant.'

        ENUMERABLE_METHOD_NAMES = (Enumerable.instance_methods + [:each]).to_set.freeze
        NONMUTATING_ARRAY_METHODS = %i[& * + - <=> == [] all? any? assoc at
                                       bsearch bsearch_index collect combination
                                       compact count cycle deconstruct difference dig
                                       drop drop_while each each_index empty? eql?
                                       fetch filter find_index first flatten hash
                                       include? index inspect intersection join
                                       last length map max min minmax none? one? pack
                                       permutation product rassoc reject
                                       repeated_combination repeated_permutation reverse
                                       reverse_each rindex rotate sample select shuffle
                                       size slice sort sum take take_while
                                       to_a to_ary to_h to_s transpose union uniq
                                       values_at zip |].freeze

        ARRAY_METHODS = (ENUMERABLE_METHOD_NAMES | NONMUTATING_ARRAY_METHODS).to_set.freeze

        NONMUTATING_HASH_METHODS = %i[< <= == > >= [] any? assoc compact dig
                                      each each_key each_pair each_value empty?
                                      eql? fetch fetch_values filter flatten has_key?
                                      has_value? hash include? inspect invert key key?
                                      keys? length member? merge rassoc rehash reject
                                      select size slice to_a to_h to_hash to_proc to_s
                                      transform_keys transform_values value? values values_at].freeze

        HASH_METHODS = (ENUMERABLE_METHOD_NAMES | NONMUTATING_HASH_METHODS).to_set.freeze

        def on_send(node)
          receiver, method, = *node.children
          return unless check_literal?(receiver, method) && parent_is_method?(receiver)

          message = format(MSG, literal_class: literal_class(receiver))
          add_offense(receiver, message: message)
        end

        private

        def check_literal?(node, method)
          !node.nil? &&
            nonmutable_method_of_array_or_hash?(node, method) &&
            node.children.size >= min_size &&
            node.recursive_basic_literal?
        end

        def nonmutable_method_of_array_or_hash?(node, method)
          (node.array_type? && ARRAY_METHODS.include?(method)) ||
            (node.hash_type? && HASH_METHODS.include?(method))
        end

        def parent_is_method?(node)
          node.each_ancestor.any? { |ancestor| method?(ancestor) || singleton_method?(ancestor) }
        end

        def method?(ancestor)
          ancestor.def_type?
        end

        def singleton_method?(ancestor)
          ancestor.defs_type?
        end

        def literal_class(node)
          if node.array_type?
            'Array'
          elsif node.hash_type?
            'Hash'
          end
        end

        def min_size
          Integer(cop_config['MinSize'] || 1)
        end
      end
    end
  end
end
