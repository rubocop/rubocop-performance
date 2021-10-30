# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Performance::ConcurrentMonotonicTime, :config do
  it 'registers an offense when using `Concurrent.monotonic_time`' do
    expect_offense(<<~RUBY)
      Concurrent.monotonic_time
      ^^^^^^^^^^^^^^^^^^^^^^^^^ Use `Process.clock_gettime(Process::CLOCK_MONOTONIC)` instead of `Concurrent.monotonic_time`.
    RUBY

    expect_correction(<<~RUBY)
      Process.clock_gettime(Process::CLOCK_MONOTONIC)
    RUBY
  end

  it 'registers an offense when using `::Concurrent.monotonic_time`' do
    expect_offense(<<~RUBY)
      ::Concurrent.monotonic_time
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use `Process.clock_gettime(Process::CLOCK_MONOTONIC)` instead of `::Concurrent.monotonic_time`.
    RUBY

    expect_correction(<<~RUBY)
      Process.clock_gettime(Process::CLOCK_MONOTONIC)
    RUBY
  end

  it 'registers an offense when using `Concurrent.monotonic_time` with an optional unit parameter' do
    expect_offense(<<~RUBY)
      Concurrent.monotonic_time(:float_second)
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use `Process.clock_gettime(Process::CLOCK_MONOTONIC, :float_second)` instead of `Concurrent.monotonic_time(:float_second)`.
    RUBY

    expect_correction(<<~RUBY)
      Process.clock_gettime(Process::CLOCK_MONOTONIC, :float_second)
    RUBY
  end

  it 'does not register an offense when using `Process.clock_gettime(Process::CLOCK_MONOTONIC)`' do
    expect_no_offenses(<<~RUBY)
      Process.clock_gettime(Process::CLOCK_MONOTONIC)
    RUBY
  end
end
