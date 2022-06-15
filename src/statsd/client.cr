require "socket"

require "./methods"

module Statsd
  class Client
    include Methods

    def self.new(host : String = "127.0.0.1", port : Int = 8125)
      new(Socket::IPAddress.new(host, port))
    end

    def initialize(@destination = Socket::IPAddress.new("127.0.0.1", 8125))
      @client = UDPSocket.new
    end

    def host
      @destination.address
    end

    def port
      @destination.port
    end

    private def send_metric(name, value, metric_type, sample_rate = nil, tags = nil)
      message = MetricMessage.serialize_metric(
        name,
        value,
        metric_type,
        sample_rate,
        tags)

      begin
        @client.send(message, @destination)
      rescue ex : IO::Error
      end
    end
  end
end
