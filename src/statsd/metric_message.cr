module Statsd
  module MetricMessage
    # Serialize the MetricMessage to a Datagram-formatted String
    #
    # Examples of valid datagrams format combinations:
    # ```
    # metric.name:value|type
    # metric.name:value|type|@sample_rate
    # metric.name:value|type|#tag1:value,tag2
    # metric.name:value|type|@sample_rate|#tag1:value,tag2:value
    # ```

    # :nodoc:
    def self.serialize_metric(
                              name : String,
                              value : Number::Primitive,
                              metric_type : String,
                              sample_rate : Number::Primitive | Nil = nil,
                              tags : Array(String)? = nil)
      String.build do |io|
        io << name << ":" << value << "|" << metric_type
        io << "|@" << sample_rate if sample_rate
        io << "|#" << tags.join(",") if tags
      end
    end
  end
end
