# frozen_string_literal: true

require_relative 'helper'

# https://github.com/rubocop/rubocop/pull/4078

def if_block(&block)
  !!block
end

def if_block_given
  !!block_given?
end

bench_perf_and_mem(result: <<~RESULT) do |x|
  ********* IPS *********
  ruby 3.3.5 (2024-09-03 revision ef084cc8f4) [x86_64-linux]
  Warming up --------------------------------------
          caller.first    27.889k i/100ms
    caller(1..1).first   176.175k i/100ms
  Calculating -------------------------------------
          caller.first    276.393k (± 5.1%) i/s    (3.62 μs/i) -      1.394M in   5.059621s
    caller(1..1).first      1.955M (± 0.6%) i/s  (511.52 ns/i) -      9.866M in   5.046684s
  
  Comparison:
    caller(1..1).first:  1954971.3 i/s
          caller.first:   276393.2 i/s - 7.07x  slower
  
  ********* MEMORY *********
  Calculating -------------------------------------
          caller.first     3.853k memsize (     0.000  retained)
                          16.000  objects (     0.000  retained)
                          14.000  strings (     0.000  retained)
    caller(1..1).first   631.000  memsize (     0.000  retained)
                           3.000  objects (     0.000  retained)
                           1.000  strings (     0.000  retained)
  
  Comparison:
    caller(1..1).first:        631 allocated
          caller.first:       3853 allocated - 6.11x more
RESULT
  x.report('caller.first')       { caller.first }
  x.report('caller(1..1).first') { caller(1, 1).first }
end

# https://github.com/rubocop/rubocop/pull/4551

def method_for_backtrace(&block)
  tap do
    tap(&block)
  end
end

bench_perf_and_mem(result: <<~RESULT) do |x|
  ********* IPS *********
  ruby 3.3.5 (2024-09-03 revision ef084cc8f4) [x86_64-linux]
  Warming up --------------------------------------
   caller_locations[1]   161.904k i/100ms
  caller_locations(2..2).first
                         634.169k i/100ms
  Calculating -------------------------------------
   caller_locations[1]      1.607M (± 1.6%) i/s  (622.29 ns/i) -      8.095M in   5.038887s
  caller_locations(2..2).first
                            6.324M (± 2.7%) i/s  (158.12 ns/i) -     31.708M in   5.017777s
  
  Comparison:
  caller_locations(2..2).first:  6324291.6 i/s
   caller_locations[1]:  1606971.6 i/s - 3.94x  slower
  
  ********* MEMORY *********
  Calculating -------------------------------------
   caller_locations[1]     1.920k memsize (     0.000  retained)
                          16.000  objects (     0.000  retained)
                           0.000  strings (     0.000  retained)
  caller_locations(2..2).first
                         280.000  memsize (     0.000  retained)
                           3.000  objects (     0.000  retained)
                           0.000  strings (     0.000  retained)
  
  Comparison:
  caller_locations(2..2).first:        280 allocated
   caller_locations[1]:       1920 allocated - 6.86x more
RESULT
  x.report('caller_locations[1]')          { caller_locations[1] }
  x.report('caller_locations(2..2).first') { caller_locations(2..2).first }
end
