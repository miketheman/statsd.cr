module Statsd
  struct MetricMessage
    def initialize(
      @name : String,
      @value : Number,
      @metric_type : String,
      @sample_rate = nil,
      @tags : Array(String)? = nil,
    )
    end

    # Convert the MetricMessage to a Datagram-formatted String
    #
    # Examples of valid datagrams format combinations:
    # ```
    # metric.name:value|type
    # metric.name:value|type|@sample_rate
    # metric.name:value|type|#tag1:value,tag2
    # metric.name:value|type|@sample_rate|#tag1:value,tag2:value
    # ```
    def to_s(io : IO)
      io << @name << ":" << @value << "|" << @metric_type

      io << "|@" << @sample_rate if @sample_rate

      if tags = @tags
        io << "|#" << tags.join(",")
      end
    end
  end
end
