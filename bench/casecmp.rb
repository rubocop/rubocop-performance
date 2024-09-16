# frozen_string_literal: true

require_relative 'helper'

# https://github.com/rubocop/rubocop/pull/2617#issuecomment-171866399

STRING = 'sTrInG'

bench_perf_and_mem(result: <<~RESULT) do |x|
  ********* IPS *********
  ruby 3.3.5 (2024-09-03 revision ef084cc8f4) [x86_64-linux]
  Warming up --------------------------------------
              ==           1.750M i/100ms
              .zero?       1.746M i/100ms
              downcase     1.210M i/100ms
  Calculating -------------------------------------
              ==           17.476M (± 0.9%) i/s   (57.22 ns/i) -     87.511M in   5.008007s
              .zero?       17.438M (± 0.3%) i/s   (57.35 ns/i) -     87.300M in   5.006306s
              downcase     11.805M (± 0.9%) i/s   (84.71 ns/i) -     59.299M in   5.023822s
  
  Comparison:
              ==      : 17475858.5 i/s
              .zero?  : 17438204.9 i/s - same-ish: difference falls within error
              downcase: 11804533.6 i/s - 1.48x  slower
  
  ********* MEMORY *********
  Calculating -------------------------------------
              ==           0.000  memsize (     0.000  retained)
                           0.000  objects (     0.000  retained)
                           0.000  strings (     0.000  retained)
              .zero?       0.000  memsize (     0.000  retained)
                           0.000  objects (     0.000  retained)
                           0.000  strings (     0.000  retained)
              downcase    40.000  memsize (     0.000  retained)
                           1.000  objects (     0.000  retained)
                           1.000  strings (     0.000  retained)
  
  Comparison:
              ==      :          0 allocated
              .zero?  :          0 allocated - same
              downcase:         40 allocated - Infx more
RESULT
  x.report('==      ') { STRING.casecmp('string') == 0 } # rubocop:disable Style/NumericPredicate
  x.report('.zero?  ') { STRING.casecmp('string').zero? }
  x.report('downcase') { STRING.downcase == 'string' }
end
