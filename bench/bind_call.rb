# frozen_string_literal: true

require_relative 'helper'

# https://github.com/rubocop/rubocop-performance/pull/92

umethod = String.instance_method(:start_with?)
bench_perf_and_mem(result: <<~RESULT) do |x|
  ********* IPS *********
  ruby 3.3.5 (2024-09-03 revision ef084cc8f4) [x86_64-linux]
  Warming up --------------------------------------
             bind.call   592.951k i/100ms
             bind_call     1.151M i/100ms
  Calculating -------------------------------------
             bind.call      5.925M (± 0.5%) i/s  (168.78 ns/i) -     29.648M in   5.003961s
             bind_call     11.575M (± 1.4%) i/s   (86.40 ns/i) -     58.722M in   5.074287s
  
  Comparison:
             bind_call: 11574705.6 i/s
             bind.call:  5924959.7 i/s - 1.95x  slower
  
  ********* MEMORY *********
  Calculating -------------------------------------
             bind.call    80.000  memsize (     0.000  retained)
                           1.000  objects (     0.000  retained)
                           0.000  strings (     0.000  retained)
             bind_call     0.000  memsize (     0.000  retained)
                           0.000  objects (     0.000  retained)
                           0.000  strings (     0.000  retained)
  
  Comparison:
             bind_call:          0 allocated
             bind.call:         80 allocated - Infx more
RESULT
  x.report('bind.call') { umethod.bind('hello, world').call('hello') }
  x.report('bind_call') { umethod.bind_call('hello, world', 'hello') }
end
