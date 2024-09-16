# frozen_string_literal: true

require_relative 'helper'

# https://github.com/rubocop/rubocop/pull/6188

ARRAY = [2, 4, 6].freeze

def splat_first(foo)
  case foo
  when *ARRAY
    'even'
  when 1
    'special'
  end
end

def splat_last(foo)
  case foo
  when 1
    'special'
  when *ARRAY
    'even'
  end
end

bench_perf_and_mem(result: <<~RESULT) do |x|
  ********* IPS *********
  ruby 3.3.5 (2024-09-03 revision ef084cc8f4) [x86_64-linux]
  Warming up --------------------------------------
           splat_first   490.988k i/100ms
            splat_last   779.542k i/100ms
  Calculating -------------------------------------
           splat_first      4.922M (± 0.2%) i/s  (203.16 ns/i) -     25.040M in   5.087205s
            splat_last      7.820M (± 0.2%) i/s  (127.88 ns/i) -     39.757M in   5.084194s
  
  Comparison:
            splat_last:  7819683.6 i/s
           splat_first:  4922251.1 i/s - 1.59x  slower
  
  ********* MEMORY *********
  Calculating -------------------------------------
           splat_first     0.000  memsize (     0.000  retained)
                           0.000  objects (     0.000  retained)
                           0.000  strings (     0.000  retained)
            splat_last     0.000  memsize (     0.000  retained)
                           0.000  objects (     0.000  retained)
                           0.000  strings (     0.000  retained)
  
  Comparison:
           splat_first:          0 allocated
            splat_last:          0 allocated - same
RESULT
  x.report('splat_first') do
    splat_first(1)
    splat_first(2)
  end
  x.report('splat_last') do
    splat_last(1)
    splat_last(2)
  end
end
