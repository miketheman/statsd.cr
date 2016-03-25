module Statsd
  struct MetricMessage
    def initialize(
      @name : String,
      @value : Number,
      @metric_type : String,
      @sample_rate = nil
    )
    end

    def to_s(io : IO)
      io << @name << ":" << @value << "|" << @metric_type

      io << "|@" << @sample_rate if @sample_rate
    end
  end
end
