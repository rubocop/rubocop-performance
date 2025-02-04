# frozen_string_literal: true

require_relative 'helper'

# https://github.com/rubocop/rubocop/pull/6234#issuecomment-417339749

ARRAY = %w[a b c d e f g h i j k l m n o p q r s t u v w x y z].freeze

bench_perf_and_mem(result: <<~RESULT) do |x|
  ********* IPS *********
  ruby 3.3.5 (2024-09-03 revision ef084cc8f4) [x86_64-linux]
  Warming up --------------------------------------
                mutate   119.467k i/100ms
                 chain   123.507k i/100ms
  Calculating -------------------------------------
                mutate      1.179M (± 0.5%) i/s  (848.40 ns/i) -      5.973M in   5.067922s
                 chain      1.210M (± 0.4%) i/s  (826.68 ns/i) -      6.052M in   5.003008s
  
  Comparison:
                 chain:  1209663.0 i/s
                mutate:  1178682.5 i/s - 1.03x  slower
  
  ********* MEMORY *********
  Calculating -------------------------------------
                mutate   248.000  memsize (     0.000  retained)
                           1.000  objects (     0.000  retained)
                           0.000  strings (     0.000  retained)
                 chain   360.000  memsize (     0.000  retained)
                           2.000  objects (     0.000  retained)
                           0.000  strings (     0.000  retained)
  
  Comparison:
                mutate:        248 allocated
                 chain:        360 allocated - 1.45x mor
RESULT
  x.report('mutate') do
    a = ARRAY.flatten
    a.compact!
    a
  end
  x.report('chain') do
    ARRAY.flatten.compact
  end
end
