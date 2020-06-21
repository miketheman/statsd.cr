require "logger"
require "socket"

require "./methods"

module Statsd
  class Client
    include Methods

    def initialize(@host = "127.0.0.1", @port = 8125)
      @client = UDPSocket.new
      @destination = Socket::IPAddress.new(@host, @port)
    end

    getter :host, :port

    # StatsD host. Defaults to 127.0.0.1.
    def host=(host)
      @host = host || "127.0.0.1"
    end

    # StatsD port. Defaults to 8125.
    def port=(port)
      @port = port || 8125
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
