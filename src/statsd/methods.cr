module Statsd
  module Methods
    # Gauge
    #
    # A gauge is an instantaneous measurement of a value, like the gas gauge in a car.
    # It differs from a counter by being calculated at the client rather than the server.
    # Valid gauge values are in the range [0, 2^64^)
    def gauge(metric_name, value, tags = nil)
      raise "Gauges may only receive positive values" unless positive? value
      send_metric(metric_name, value, "g", tags: tags)
    end

    # Counters
    #
    # A counter is a gauge calculated at the server.
    # Metrics sent by the client increment or decrement the value of the gauge rather than giving its current value.
    # Counters may also have an associated sample rate, given as a decimal of the number of samples per event count.
    # For example, a sample rate of 1/10 would be exported as 0.1.
    # Valid counter values are in the range (-2^63^, 2^63^).
    #
    # Example:
    # ```
    # <metric name>:<value>|c[|@<sample rate>]
    # ```

    def increment(metric_name, sample_rate = nil, tags = nil)
      send_metric(metric_name, 1, "c", sample_rate, tags: tags)
    end

    def decrement(metric_name, sample_rate = nil, tags = nil)
      send_metric(metric_name, -1, "c", sample_rate, tags: tags)
    end

    # Timers
    #
    # A timer is a measure of the number of milliseconds elapsed between a start and end time,
    # for example the time to complete rendering of a web page for a user.
    # Valid timer values are in the range [0, 2^64^).
    #
    # Example:
    # ```
    # <metric name>:<value>|ms
    # ```

    # Send a timing as a metric.
    # This is sending a time measurement, as calculated by some other code, in milliseconds.
    #
    # Example:
    # ```
    # stastd.timing("db.query", 200)
    # ```
    def timing(metric_name, ms, tags = nil)
      raise "Timers may only receive positive values" unless positive? ms
      send_metric(metric_name, ms, "ms", tags: tags)
    end

    # Measure execution time of a given block, using {#timing}.
    def time(metric_name, tags = nil)
      start = Time.monotonic
      yield
    ensure
      if start
        timing(metric_name, (Time.monotonic - start).total_milliseconds, tags: tags)
      end
    end

    # Sets
    #
    # StatsD supports counting unique occurences of events between flushes, using a Set to store all occuring events.
    # Example:
    # ```
    # <metric name>:<value>|s
    # ```
    def set(metric_name, value, tags = nil)
      send_metric(metric_name, value, "s", tags: tags)
    end

    # Histograms
    #
    # A histogram is a measure of the distribution of timer values over time, calculated at the server.
    # As the data exported for timers and histograms is the same, this is currently an alias for a timer.
    # Valid histogram values are in the range [0, 2^64^).
    #
    # Example:
    # ```
    # <metric name>:<value>|h
    # ```
    def histogram(metric_name, value, tags = nil)
      raise "Histograms may only receive positive values" unless positive? value
      send_metric(metric_name, value, "h", tags: tags)
    end

    # Helpers

    # Determine if a given Number is positive or not
    # See http://crystal-lang.org/api/Number.html#sign-instance-method
    private def positive?(number)
      number.sign == -1 ? false : true
    end
  end
end
