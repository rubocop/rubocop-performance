# frozen_string_literal: true

require 'benchmark/ips'
require 'benchmark-memory'

def bench_perf_and_mem(result: nil)
  warn 'Document the result of the benchmark!' unless result

  puts('********* IPS *********')
  Benchmark.ips do |x|
    yield(x)
    x.compare!
  end

  puts '********* MEMORY *********'
  Benchmark.memory do |x|
    yield(x)
    x.compare!
  end
end
