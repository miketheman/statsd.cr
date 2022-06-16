require "../spec_helper"

describe Statsd::Client do
  describe "#initialize" do
    it "should set the host and port" do
      statsd = Statsd::Client.new("127.0.0.1", 1234)
      statsd.host.should eq "127.0.0.1"
      statsd.port.should eq 1234
    end

    it "should default the host to 127.0.0.1 and port to 8125" do
      statsd = Statsd::Client.new
      statsd.host.should eq "127.0.0.1"
      statsd.port.should eq 8125
    end

    it "accepts an IPAddress" do
      statsd = Statsd::Client.new Socket::IPAddress.new("127.0.0.2", 2345)
      statsd.host.should eq "127.0.0.2"
      statsd.port.should eq 2345
    end
  end

  describe "no server" do
    it "sends messages when nodoby is listening" do
      statsd = Statsd::Client.new(host: "127.0.0.1", port: 1234)

      5.times do
        statsd.increment "foobar"
      end

      5.times do
        statsd.gauge "barfoo", 1
      end
    end
  end
end
