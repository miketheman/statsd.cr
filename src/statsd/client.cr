require "logger"
require "socket"

require "./methods"

module Statsd
  class Client
    include Methods

    def initialize(@host = "127.0.0.1", @port = 8125)
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

      send_to_socket message
    end

    private def send_to_socket(message)
      socket = UDPSocket.new
      socket.connect(@host, @port)
      socket << message.to_s
      socket.close
    end
  end
end
