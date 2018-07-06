# frozen_string_literal: true

module RuboCop
  module Cop
    # RuboCop included the performance cops directly before version 1.0.0.
    # We can remove them to avoid warnings about redefining constants.
    remove_const('Performance') if const_defined?('Performance')
  end
end

require_relative 'performance/caller'
require_relative 'performance/case_when_splat'
require_relative 'performance/casecmp'
require_relative 'performance/compare_with_block'
require_relative 'performance/count'
require_relative 'performance/detect'
require_relative 'performance/double_start_end_with'
require_relative 'performance/end_with'
require_relative 'performance/fixed_size'
require_relative 'performance/flat_map'
require_relative 'performance/inefficient_hash_search'
require_relative 'performance/lstrip_rstrip'
require_relative 'performance/range_include'
require_relative 'performance/redundant_block_call'
require_relative 'performance/redundant_match'
require_relative 'performance/redundant_merge'
require_relative 'performance/redundant_sort_by'
require_relative 'performance/regexp_match'
require_relative 'performance/reverse_each'
require_relative 'performance/sample'
require_relative 'performance/size'
require_relative 'performance/start_with'
require_relative 'performance/string_replacement'
require_relative 'performance/times_map'
require_relative 'performance/unfreeze_string'
require_relative 'performance/unneeded_sort'
require_relative 'performance/uri_default_parser'
