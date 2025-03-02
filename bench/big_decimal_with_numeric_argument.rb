# frozen_string_literal: true

require 'bigdecimal'
require_relative 'helper'

# https://github.com/rubocop/rubocop-performance/issues/454

bench_perf_and_mem(result: <<~RESULT) do |x|
  ********* IPS *********
  ruby 3.3.5 (2024-09-03 revision ef084cc8f4) [x86_64-linux]
  Warming up --------------------------------------
  integer string new k   395.535k i/100ms
         integer new k   809.005k i/100ms
  integer string new kk
                         408.044k i/100ms
        integer new kk   842.660k i/100ms
  integer string new m   389.366k i/100ms
         integer new m   813.443k i/100ms
  Calculating -------------------------------------
  integer string new k      4.302M (± 2.5%) i/s  (232.47 ns/i) -     21.754M in   5.061086s
         integer new k      8.795M (± 1.2%) i/s  (113.70 ns/i) -     44.495M in   5.059773s
  integer string new kk
                            4.075M (± 4.0%) i/s  (245.43 ns/i) -     20.402M in   5.015977s
        integer new kk      8.344M (± 7.0%) i/s  (119.84 ns/i) -     42.133M in   5.077733s
  integer string new m      3.754M (± 6.1%) i/s  (266.40 ns/i) -     18.690M in   5.002906s
         integer new m      8.590M (± 0.5%) i/s  (116.42 ns/i) -     43.112M in   5.019137s
  
  Comparison:
         integer new k:  8795119.7 i/s
         integer new m:  8589857.9 i/s - 1.02x  slower
        integer new kk:  8344151.7 i/s - same-ish: difference falls within error
  integer string new k:  4301578.6 i/s - 2.04x  slower
  integer string new kk:  4074549.8 i/s - 2.16x  slower
  integer string new m:  3753692.1 i/s - 2.34x  slower
  
  ********* MEMORY *********
  Calculating -------------------------------------
  integer string new k    88.000  memsize (     0.000  retained)
                           1.000  objects (     0.000  retained)
                           0.000  strings (     0.000  retained)
         integer new k    84.000  memsize (     0.000  retained)
                           1.000  objects (     0.000  retained)
                           0.000  strings (     0.000  retained)
  integer string new kk
                          88.000  memsize (     0.000  retained)
                           1.000  objects (     0.000  retained)
                           0.000  strings (     0.000  retained)
        integer new kk    84.000  memsize (     0.000  retained)
                           1.000  objects (     0.000  retained)
                           0.000  strings (     0.000  retained)
  integer string new m    92.000  memsize (     0.000  retained)
                           1.000  objects (     0.000  retained)
                           0.000  strings (     0.000  retained)
         integer new m    84.000  memsize (     0.000  retained)
                           1.000  objects (     0.000  retained)
                           0.000  strings (     0.000  retained)
  
  Comparison:
         integer new k:         84 allocated
        integer new kk:         84 allocated - same
         integer new m:         84 allocated - same
  integer string new k:         88 allocated - 1.05x more
  integer string new kk:         88 allocated - 1.05x more
  integer string new m:         92 allocated - 1.10x more
RESULT
  x.report('integer string new k')  { BigDecimal('2000') }
  x.report('integer new k')         { BigDecimal(2000) }

  x.report('integer string new kk')  { BigDecimal('2000000') }
  x.report('integer new kk')         { BigDecimal(2_000_000) }

  x.report('integer string new m')  { BigDecimal('2000000000') }
  x.report('integer new m')         { BigDecimal(2_000_000_000) }
end
