# frozen_string_literal: true

require_relative 'helper'

# https://github.com/rubocop/rubocop-performance/issues/385

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
                 block     1.688M i/100ms
        block w/ block   579.312k i/100ms
          block_given?     1.650M i/100ms
  block_given? w/ block
                           1.627M i/100ms
  Calculating -------------------------------------
                 block     17.046M (± 2.5%) i/s   (58.66 ns/i) -     86.089M in   5.053948s
        block w/ block      5.667M (± 0.5%) i/s  (176.46 ns/i) -     28.386M in   5.009222s
          block_given?     16.656M (± 0.8%) i/s   (60.04 ns/i) -     84.158M in   5.053201s
  block_given? w/ block
                           16.349M (± 1.9%) i/s   (61.17 ns/i) -     82.981M in   5.077449s
  
  Comparison:
                 block: 17046107.5 i/s
          block_given?: 16655519.1 i/s - same-ish: difference falls within error
  block_given? w/ block: 16349006.7 i/s - same-ish: difference falls within error
        block w/ block:  5666956.8 i/s - 3.01x  slower
  
  ********* MEMORY *********
  Calculating -------------------------------------
                 block     0.000  memsize (     0.000  retained)
                           0.000  objects (     0.000  retained)
                           0.000  strings (     0.000  retained)
        block w/ block    80.000  memsize (     0.000  retained)
                           1.000  objects (     0.000  retained)
                           0.000  strings (     0.000  retained)
          block_given?     0.000  memsize (     0.000  retained)
                           0.000  objects (     0.000  retained)
                           0.000  strings (     0.000  retained)
  block_given? w/ block
                           0.000  memsize (     0.000  retained)
                           0.000  objects (     0.000  retained)
                           0.000  strings (     0.000  retained)
  
  Comparison:
                 block:          0 allocated
          block_given?:          0 allocated - same
  block_given? w/ block:          0 allocated - same
        block w/ block:         80 allocated - Infx more
RESULT
  x.report('block')                  { if_block }
  x.report('block w/ block')         { if_block {} } # rubocop:disable Lint/EmptyBlock
  x.report('block_given?')           { if_block_given }
  x.report('block_given? w/ block')  { if_block_given {} } # rubocop:disable Lint/EmptyBlock
end
