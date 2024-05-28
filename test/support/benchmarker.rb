require "minitest/autorun"
require "benchmark"

module Benchmarker
  def assert_benchmark(description, percentile:, max_time_ms:, runs:, &block)
    report = runs.times.map { Benchmark.ms(&block) }

    percentile_time = calculate_percentile_time(report, percentile)
    error_message = "#{description} exceeded #{percentile} percentile time of #{max_time_ms}ms"
    assert_operator percentile_time, :<, max_time_ms, error_message
  end

  def calculate_percentile_time(report, percentile)
    report.sort[report.size * percentile / 100]
  end
end
