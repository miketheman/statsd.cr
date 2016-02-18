require "logger"
require "socket"

require "./methods"

module Statsd
  class Client
    include Methods

    def initialize(@host = "127.0.0.1", @port = 8125)
      @client = UDPSocket.new
      @destination = Socket::IPAddress.new(Socket::Family::INET, @host, @port)
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

    private def send_metric(name, value, metric_type, sample_rate = nil)
      message = MetricMessage.new(
        name,
        value,
        metric_type,
        sample_rate,
      )

      begin
        @client.send(message.to_s, @destination)
      rescue ex : Errno
        if ex.errno == Errno::ECONNREFUSED
          # TODO: add a debug log event here if this occurs
        end
      end
    end
  end
end
