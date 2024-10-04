# frozen_string_literal: true

require_relative 'helper'

CHECKED = [3.3].freeze

# https://github.com/rubocop/rubocop-performance/pull/175#issuecomment-732061953

ARRAY = (1..100).to_a
range_take3 = (..2).freeze
range_drop90 = (90..).freeze

bench_perf_and_mem(result: <<~RESULT) do |x|
  ********* IPS *********
  ruby 3.3.5 (2024-09-03 revision ef084cc8f4) [x86_64-linux]
  Warming up --------------------------------------
         Array#take(3)     1.436M i/100ms
           Array#[..2]     1.266M i/100ms
       var Array#[..2]     1.253M i/100ms
  Calculating -------------------------------------
         Array#take(3)     14.001M (± 1.0%) i/s   (71.42 ns/i) -     70.365M in   5.026331s
           Array#[..2]     12.494M (± 1.3%) i/s   (80.04 ns/i) -     63.316M in   5.068820s
       var Array#[..2]     12.497M (± 1.2%) i/s   (80.02 ns/i) -     62.650M in   5.013754s
  
  Comparison:
         Array#take(3): 14000869.7 i/s
       var Array#[..2]: 12497303.5 i/s - 1.12x  slower
           Array#[..2]: 12493580.2 i/s - 1.12x  slower
  
  ********* MEMORY *********
  Calculating -------------------------------------
         Array#take(3)    40.000  memsize (     0.000  retained)
                           1.000  objects (     0.000  retained)
                           0.000  strings (     0.000  retained)
           Array#[..2]    40.000  memsize (     0.000  retained)
                           1.000  objects (     0.000  retained)
                           0.000  strings (     0.000  retained)
       var Array#[..2]    40.000  memsize (     0.000  retained)
                           1.000  objects (     0.000  retained)
                           0.000  strings (     0.000  retained)
  
  Comparison:
         Array#take(3):         40 allocated
           Array#[..2]:         40 allocated - same
       var Array#[..2]:         40 allocated - same
RESULT
  x.report('Array#take(3)')    { ARRAY.take(3) }
  x.report('Array#[..2]')      { ARRAY[..2] }
  x.report('var Array#[..2]')  { ARRAY[range_take3] }
end

bench_perf_and_mem(result: <<~RESULT) do |x|
  ********* IPS *********
  ruby 3.3.5 (2024-09-03 revision ef084cc8f4) [x86_64-linux]
  Warming up --------------------------------------
        Array#drop(90)     1.394M i/100ms
          Array#[90..]     1.255M i/100ms
      var Array#[90..]     1.256M i/100ms
  Calculating -------------------------------------
        Array#drop(90)     13.911M (± 1.4%) i/s   (71.88 ns/i) -     69.683M in   5.010116s
          Array#[90..]     12.785M (± 0.5%) i/s   (78.21 ns/i) -     63.983M in   5.004532s
      var Array#[90..]     12.784M (± 0.6%) i/s   (78.23 ns/i) -     64.062M in   5.011440s
  
  Comparison:
        Array#drop(90): 13911240.1 i/s
          Array#[90..]: 12785455.6 i/s - 1.09x  slower
      var Array#[90..]: 12783591.2 i/s - 1.09x  slower
  
  ********* MEMORY *********
  Calculating -------------------------------------
        Array#drop(90)    40.000  memsize (     0.000  retained)
                           1.000  objects (     0.000  retained)
                           0.000  strings (     0.000  retained)
          Array#[90..]    40.000  memsize (     0.000  retained)
                           1.000  objects (     0.000  retained)
                           0.000  strings (     0.000  retained)
      var Array#[90..]    40.000  memsize (     0.000  retained)
                           1.000  objects (     0.000  retained)
                           0.000  strings (     0.000  retained)
  
  Comparison:
        Array#drop(90):         40 allocated
          Array#[90..]:         40 allocated - same
      var Array#[90..]:         40 allocated - same
RESULT
  x.report('Array#drop(90)')   { ARRAY.drop(90) }
  x.report('Array#[90..]')     { ARRAY[90..] }
  x.report('var Array#[90..]') { ARRAY[range_drop90] }
end
