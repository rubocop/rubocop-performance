# frozen_string_literal: true

require_relative 'mixin/regexp_metacharacter'
require_relative 'mixin/sort_block'

require_relative 'performance/ancestors_include'
require_relative 'performance/array_concat_literal'
require_relative 'performance/array_push_single'
require_relative 'performance/array_semi_infinite_range_slice'
require_relative 'performance/big_decimal_with_numeric_argument'
require_relative 'performance/bind_call'
require_relative 'performance/block_given_with_explicit_block'
require_relative 'performance/caller'
require_relative 'performance/case_when_splat'
require_relative 'performance/casecmp'
require_relative 'performance/collection_literal_in_loop'
require_relative 'performance/compare_with_block'
require_relative 'performance/concurrent_monotonic_time'
require_relative 'performance/constant_regexp'
require_relative 'performance/count'
require_relative 'performance/delete_prefix'
require_relative 'performance/delete_suffix'
require_relative 'performance/detect'
require_relative 'performance/double_start_end_with'
require_relative 'performance/end_with'
require_relative 'performance/fixed_size'
require_relative 'performance/flat_map'
require_relative 'performance/inefficient_hash_search'
require_relative 'performance/map_compact'
require_relative 'performance/map_method_chain'
require_relative 'performance/method_object_as_block'
require_relative 'performance/open_struct'
require_relative 'performance/range_include'
require_relative 'performance/io_readlines'
require_relative 'performance/redundant_block_call'
require_relative 'performance/redundant_equality_comparison_block'
require_relative 'performance/redundant_match'
require_relative 'performance/redundant_merge'
require_relative 'performance/redundant_sort_block'
require_relative 'performance/redundant_split_regexp_argument'
require_relative 'performance/redundant_string_chars'
require_relative 'performance/regexp_match'
require_relative 'performance/reverse_each'
require_relative 'performance/reverse_first'
require_relative 'performance/select_map'
require_relative 'performance/size'
require_relative 'performance/sort_reverse'
require_relative 'performance/squeeze'
require_relative 'performance/start_with'
require_relative 'performance/string_identifier_argument'
require_relative 'performance/string_include'
require_relative 'performance/string_replacement'
require_relative 'performance/sum'
require_relative 'performance/times_map'
require_relative 'performance/unfreeze_string'
require_relative 'performance/uri_default_parser'
require_relative 'performance/chain_array_allocation'
