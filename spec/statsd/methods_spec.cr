require "../spec_helper"

describe Statsd::Methods do
  describe "#gauge" do
    server = UDPSocket.new
    server.bind("localhost", 1234)

    statsd = Statsd::Client.new(host: "localhost", port: 1234)

    it "should format the message according to the statsd spec" do
      statsd.gauge("foobar", 20)
      expected_message = "foobar:20|g"
      server.gets(expected_message.bytesize).should eq expected_message
    end

    it "should allow a zero value" do
      statsd.gauge("foobar", 0)
      expected_message = "foobar:0|g"
      server.gets(expected_message.bytesize).should eq expected_message
    end

    it "should allow a UInt64 value" do
      statsd.gauge("foobar", 18446744073709551615)
      expected_message = "foobar:18446744073709551615|g"
      server.gets(expected_message.bytesize).should eq expected_message
    end

    it "should raise an exception for negative values" do
      expect_raises { statsd.gauge("foobar", -1) }
    end

    server.close
  end

  context "counts" do
    describe "#increment" do
      server = UDPSocket.new
      server.bind("localhost", 1234)

      statsd = Statsd::Client.new(host: "localhost", port: 1234)

      it "should format the message according to the statsd spec" do
        statsd.increment("foobar")
        expected_message = "foobar:1|c"
        server.gets(expected_message.bytesize).should eq expected_message
      end

      describe "with a sample rate" do
        it "should format the message according to the statsd spec" do
          statsd.increment("foobar", 0.5)
          expected_message = "foobar:1|c|@0.5"
          server.gets(expected_message.bytesize).should eq expected_message
        end
      end

      server.close
    end

    describe "#decrement" do
      server = UDPSocket.new
      server.bind("localhost", 1234)

      statsd = Statsd::Client.new(host: "localhost", port: 1234)

      it "should format the message according to the statsd spec" do
        statsd.decrement("foobar")
        expected_message = "foobar:-1|c"
        server.gets(expected_message.bytesize).should eq expected_message
      end

      describe "with a sample rate" do
        it "should format the message according to the statsd spec" do
          statsd.decrement("foobar", 0.5)
          expected_message = "foobar:-1|c|@0.5"
          server.gets(expected_message.bytesize).should eq expected_message
        end
      end

      server.close
    end
  end

  context "timers" do
    describe "#timing" do
      server = UDPSocket.new
      server.bind("localhost", 1234)

      statsd = Statsd::Client.new(host: "localhost", port: 1234)

      it "should format the message according to the statsd spec" do
        statsd.timing("foobar", 500)
        expected_message = "foobar:500|ms"
        server.gets(expected_message.bytesize).should eq expected_message
      end

      it "should raise an exception for negative values" do
        expect_raises { statsd.timing("foobar", -500) }
      end

      server.close
    end

    describe "#time" do
      server = UDPSocket.new
      server.bind("localhost", 1234)

      statsd = Statsd::Client.new(host: "localhost", port: 1234)

      it "should format the message according to the statsd spec" do
        statsd.time("foobar") { "test" }
        expected_message = "foobar:0|ms"
        server.gets(expected_message.bytesize).should eq expected_message
      end

      server.close
    end
  end

  describe "#set" do
    server = UDPSocket.new
    server.bind("localhost", 1234)

    statsd = Statsd::Client.new(host: "localhost", port: 1234)

    it "should format the message according to the statsd spec" do
      statsd.set("foobar", 1)
      expected_message = "foobar:1|s"
      server.gets(expected_message.bytesize).should eq expected_message
    end

    server.close
  end

  describe "#histogram" do
    server = UDPSocket.new
    server.bind("localhost", 1234)

    statsd = Statsd::Client.new(host: "localhost", port: 1234)

    it "should format the message according to the statsd spec" do
      statsd.histogram("foobar", 50)
      expected_message = "foobar:50|h"
      server.gets(expected_message.bytesize).should eq expected_message
    end

    it "should raise an exception for negative values" do
      expect_raises { statsd.histogram("foobar", -50) }
    end

    server.close
  end
end
