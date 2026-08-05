# frozen_string_literal: true

require_relative 'mixin'

module RuboCop
  module Cop
    # Cops for the `Performance` department. The department's cops are registered for lazy loading
    # and their files are loaded on demand.
    module Performance
      extend LazyLoader

      register_cop :AncestorsInclude, "#{__dir__}/performance/ancestors_include"
      register_cop :ArraySemiInfiniteRangeSlice, "#{__dir__}/performance/array_semi_infinite_range_slice"
      register_cop :BigDecimalWithNumericArgument, "#{__dir__}/performance/big_decimal_with_numeric_argument"
      register_cop :BindCall, "#{__dir__}/performance/bind_call"
      register_cop :BlockGivenWithExplicitBlock, "#{__dir__}/performance/block_given_with_explicit_block"
      register_cop :Caller, "#{__dir__}/performance/caller"
      register_cop :CaseWhenSplat, "#{__dir__}/performance/case_when_splat"
      register_cop :Casecmp, "#{__dir__}/performance/casecmp"
      register_cop :CollectionLiteralInLoop, "#{__dir__}/performance/collection_literal_in_loop"
      register_cop :CompareWithBlock, "#{__dir__}/performance/compare_with_block"
      register_cop :ConcurrentMonotonicTime, "#{__dir__}/performance/concurrent_monotonic_time"
      register_cop :ConstantRegexp, "#{__dir__}/performance/constant_regexp"
      register_cop :Count, "#{__dir__}/performance/count"
      register_cop :DeletePrefix, "#{__dir__}/performance/delete_prefix"
      register_cop :DeleteSuffix, "#{__dir__}/performance/delete_suffix"
      register_cop :Detect, "#{__dir__}/performance/detect"
      register_cop :DoubleStartEndWith, "#{__dir__}/performance/double_start_end_with"
      register_cop :EndWith, "#{__dir__}/performance/end_with"
      register_cop :FixedSize, "#{__dir__}/performance/fixed_size"
      register_cop :FlatMap, "#{__dir__}/performance/flat_map"
      register_cop :InefficientHashSearch, "#{__dir__}/performance/inefficient_hash_search"
      register_cop :MapCompact, "#{__dir__}/performance/map_compact"
      register_cop :MapMethodChain, "#{__dir__}/performance/map_method_chain"
      register_cop :MethodObjectAsBlock, "#{__dir__}/performance/method_object_as_block"
      register_cop :OpenStruct, "#{__dir__}/performance/open_struct"
      register_cop :RangeInclude, "#{__dir__}/performance/range_include"
      register_cop :IoReadlines, "#{__dir__}/performance/io_readlines"
      register_cop :RedundantBlockCall, "#{__dir__}/performance/redundant_block_call"
      register_cop :RedundantEqualityComparisonBlock, "#{__dir__}/performance/redundant_equality_comparison_block"
      register_cop :RedundantMatch, "#{__dir__}/performance/redundant_match"
      register_cop :RedundantMerge, "#{__dir__}/performance/redundant_merge"
      register_cop :RedundantSortBlock, "#{__dir__}/performance/redundant_sort_block"
      register_cop :RedundantSplitRegexpArgument, "#{__dir__}/performance/redundant_split_regexp_argument"
      register_cop :RedundantStringChars, "#{__dir__}/performance/redundant_string_chars"
      register_cop :RegexpMatch, "#{__dir__}/performance/regexp_match"
      register_cop :ReverseEach, "#{__dir__}/performance/reverse_each"
      register_cop :ReverseFirst, "#{__dir__}/performance/reverse_first"
      register_cop :SelectMap, "#{__dir__}/performance/select_map"
      register_cop :Size, "#{__dir__}/performance/size"
      register_cop :SortReverse, "#{__dir__}/performance/sort_reverse"
      register_cop :Squeeze, "#{__dir__}/performance/squeeze"
      register_cop :StringBytesize, "#{__dir__}/performance/string_bytesize"
      register_cop :StartWith, "#{__dir__}/performance/start_with"
      register_cop :StringIdentifierArgument, "#{__dir__}/performance/string_identifier_argument"
      register_cop :StringInclude, "#{__dir__}/performance/string_include"
      register_cop :StringReplacement, "#{__dir__}/performance/string_replacement"
      register_cop :Sum, "#{__dir__}/performance/sum"
      register_cop :TimesMap, "#{__dir__}/performance/times_map"
      register_cop :UnfreezeString, "#{__dir__}/performance/unfreeze_string"
      register_cop :UriDefaultParser, "#{__dir__}/performance/uri_default_parser"
      register_cop :ChainArrayAllocation, "#{__dir__}/performance/chain_array_allocation"
      register_cop :ZipWithoutBlock, "#{__dir__}/performance/zip_without_block"
    end
  end
end
