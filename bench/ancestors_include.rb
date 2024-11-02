# frozen_string_literal: true

require_relative 'helper'

# https://github.com/rubocop/rubocop-performance/pull/123#issue-629164011

def fast
  (Class <= Class) && # rubocop:disable Lint/BinaryOperatorWithIdenticalOperands
    (Class <= Module) &&
    (Class <= Object) &&
    (Class <= Kernel) &&
    (Class <= BasicObject)
end

def slow
  Class.ancestors.include?(Class) &&
    Class.ancestors.include?(Module) &&
    Class.ancestors.include?(Object) &&
    Class.ancestors.include?(Kernel) &&
    Class.ancestors.include?(BasicObject)
end

bench_perf_and_mem(result: <<~RESULT) do |x|
  ********* IPS *********
  ruby 3.3.5 (2024-09-03 revision ef084cc8f4) [x86_64-linux]
  Warming up --------------------------------------
    less than or equal   718.264k i/100ms
    ancestors.include?   103.830k i/100ms
  Calculating -------------------------------------
    less than or equal      7.186M (± 1.2%) i/s  (139.17 ns/i) -     36.631M in   5.098690s
    ancestors.include?      1.007M (± 2.7%) i/s  (993.15 ns/i) -      5.088M in   5.056552s
  
  Comparison:
    less than or equal:  7185550.9 i/s
    ancestors.include?:  1006894.0 i/s - 7.14x  slower
  
  ********* MEMORY *********
  Calculating -------------------------------------
    less than or equal     0.000  memsize (     0.000  retained)
                           0.000  objects (     0.000  retained)
                           0.000  strings (     0.000  retained)
    ancestors.include?     1.000k memsize (     0.000  retained)
                           5.000  objects (     0.000  retained)
                           0.000  strings (     0.000  retained)
  
  Comparison:
    less than or equal:          0 allocated
    ancestors.include?:       1000 allocated - Infx more
RESULT
  x.report('less than or equal') { fast }
  x.report('ancestors.include?') { slow }
end
