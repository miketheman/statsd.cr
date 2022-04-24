module Statsd
  module Methods
    COUNTER_TYPE      = "c"
    GAUGE_TYPE        = "g"
    HISTOGRAM_TYPE    = "h"
    DISTRIBUTION_TYPE = "d"
    TIMING_TYPE       = "ms"
    SET_TYPE          = "s"

    # Gauge
    #
    # A gauge is an instantaneous measurement of a value, like the gas gauge in a car.
    # It differs from a counter by being calculated at the client rather than the server.
    # Valid gauge values are in the range [0, 2^64^)
    def gauge(metric_name, value, tags = nil)
      raise "Gauges may only receive positive values" unless positive? value
      send_metric(metric_name, value, GAUGE_TYPE, tags: tags)
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
      send_metric(metric_name, 1, COUNTER_TYPE, sample_rate, tags: tags)
    end

    def decrement(metric_name, sample_rate = nil, tags = nil)
      send_metric(metric_name, -1, COUNTER_TYPE, sample_rate, tags: tags)
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
      send_metric(metric_name, ms, TIMING_TYPE, tags: tags)
    end

    # Measure execution time of a given block, using {#timing}.
    def time(metric_name, tags = nil)
      start = Time.monotonic
      yield
    ensure
      if start
        timing(metric_name, (Time.monotonic - start).total_milliseconds.to_i, tags: tags)
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
      send_metric(metric_name, value, SET_TYPE, tags: tags)
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
      send_metric(metric_name, value, HISTOGRAM_TYPE, tags: tags)
    end

    # Distributions
    #
    # The DISTRIBUTION metric type is specific to DataDog (DogStatsD).
    #
    # The DISTRIBUTION metric submission type represents the global statistical distribution of a set of values calculated across your entire distributed infrastructure in one time interval.
    # A DISTRIBUTION can be used to instrument logical objects, like services, independently from the underlying hosts.
    #
    # Unlike the HISTOGRAM metric type, which aggregates on the Agent during a given time interval, a DISTRIBUTION metric sends all the raw data during a time interval to Datadog.
    # Aggregations occur on the server-side. Because the underlying data structure represents raw, un-aggregated data, distributions provide two major features:
    #
    # - Calculation of percentile aggregations
    # - Customization of tagging
    #
    # Like other metric types, such as GAUGE or HISTOGRAM, the DISTRIBUTION metric type has the following aggregations available:
    # count, min, max, sum, and avg
    #
    # Example:
    # ```
    # <metric name>:<value>|d
    # ```
    def distribution(metric_name, value, tags = nil)
      raise "distribution may only receive positive values" unless positive? value
      send_metric(metric_name, value, DISTRIBUTION_TYPE, tags: tags)
    end

    # Helpers

    # Determine if a given Number is positive or not
    # See http://crystal-lang.org/api/Number.html#sign-instance-method
    private def positive?(number)
      number.sign == -1 ? false : true
    end
  end
end
