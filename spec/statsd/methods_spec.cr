require "../spec_helper"

private def with_server(& : UDPSocket, Statsd::Client ->)
  server = UDPSocket.new
  server.bind("localhost", 1234)

  statsd = Statsd::Client.new(host: "127.0.0.1", port: 1234)

  yield server, statsd
ensure
  server.close if server
end

describe Statsd::Methods do
  describe "#gauge" do
    it "should format the message according to the statsd spec" do
      with_server do |server, statsd|
        statsd.gauge("foobar", 20)
        expected_message = "foobar:20|g"
        server.gets(expected_message.bytesize).should eq expected_message
      end
    end

    it "should allow a zero value" do
      with_server do |server, statsd|
        statsd.gauge("foobar", 0)
        expected_message = "foobar:0|g"
        server.gets(expected_message.bytesize).should eq expected_message
      end
    end

    it "should allow a UInt64 value" do
      with_server do |server, statsd|
        statsd.gauge("foobar", 18446744073709551615)
        expected_message = "foobar:18446744073709551615|g"
        server.gets(expected_message.bytesize).should eq expected_message
      end
    end

    it "should raise an exception for negative values" do
      with_server do |server, statsd|
        expect_raises(Exception) { statsd.gauge("foobar", -1) }
      end
    end

    it "should format the message according to the extended statsd spec" do
      with_server do |server, statsd|
        statsd.gauge("foobar", 20, tags: ["foo:bar"])
        expected_message = "foobar:20|g|#foo:bar"
        server.gets(expected_message.bytesize).should eq expected_message
      end
    end
  end

  context "counts" do
    describe "#increment" do
      it "should format the message according to the statsd spec" do
        with_server do |server, statsd|
          statsd.increment("foobar")
          expected_message = "foobar:1|c"
          server.gets(expected_message.bytesize).should eq expected_message
        end
      end

      it "should format the message according to the extended statsd spec" do
        with_server do |server, statsd|
          statsd.increment("foobar", tags: ["foo:bar"])
          expected_message = "foobar:1|c|#foo:bar"
          server.gets(expected_message.bytesize).should eq expected_message
        end
      end

      describe "with a sample rate" do
        it "should format the message according to the statsd spec" do
          with_server do |server, statsd|
            statsd.increment("foobar", 0.5)
            expected_message = "foobar:1|c|@0.5"
            server.gets(expected_message.bytesize).should eq expected_message
          end
        end

        it "should format the message according to the extended statsd spec" do
          with_server do |server, statsd|
            statsd.increment("foobar", 0.5, tags: ["foo:bar"])
            expected_message = "foobar:1|c|@0.5|#foo:bar"
            server.gets(expected_message.bytesize).should eq expected_message
          end
        end
      end
    end

    describe "#decrement" do
      it "should format the message according to the statsd spec" do
        with_server do |server, statsd|
          statsd.decrement("foobar")
          expected_message = "foobar:-1|c"
          server.gets(expected_message.bytesize).should eq expected_message
        end
      end

      it "should format the message according to the extended statsd spec" do
        with_server do |server, statsd|
          statsd.decrement("foobar", tags: ["foo:bar"])
          expected_message = "foobar:-1|c|#foo:bar"
          server.gets(expected_message.bytesize).should eq expected_message
        end
      end

      describe "with a sample rate" do
        it "should format the message according to the statsd spec" do
          with_server do |server, statsd|
            statsd.decrement("foobar", 0.5)
            expected_message = "foobar:-1|c|@0.5"
            server.gets(expected_message.bytesize).should eq expected_message
          end
        end

        it "should format the message according to the extended statsd spec" do
          with_server do |server, statsd|
            statsd.decrement("foobar", 0.5, tags: ["foo:bar"])
            expected_message = "foobar:-1|c|@0.5|#foo:bar"
            server.gets(expected_message.bytesize).should eq expected_message
          end
        end
      end
    end
  end

  context "timers" do
    describe "#timing" do
      it "should format the message according to the statsd spec" do
        with_server do |server, statsd|
          statsd.timing("foobar", 500)
          expected_message = "foobar:500|ms"
          server.gets(expected_message.bytesize).should eq expected_message
        end
      end

      it "should raise an exception for negative values" do
        with_server do |server, statsd|
          expect_raises(Exception) { statsd.timing("foobar", -500) }
        end
      end

      it "should format the message according to the extended statsd spec" do
        with_server do |server, statsd|
          statsd.timing("foobar", 500, tags: ["foo:bar"])
          expected_message = "foobar:500|ms|#foo:bar"
          server.gets(expected_message.bytesize).should eq expected_message
        end
      end
    end

    describe "#time" do
      it "should format the message according to the statsd spec" do
        with_server do |server, statsd|
          statsd.time("foobar") { "test" }
          expected_message = "foobar:0|ms"
          server.gets(expected_message.bytesize).should eq expected_message
        end
      end

      it "should format the message according to the extended statsd spec" do
        with_server do |server, statsd|
          statsd.time("foobar", tags: ["foo:bar"]) { "test" }
          expected_message = "foobar:0|ms|#foo:bar"
          server.gets(expected_message.bytesize).should eq expected_message
        end
      end

      it "should emit a timing even if the block raises" do
        with_server do |server, statsd|
          expect_raises(Exception) do
            statsd.time("foobar", tags: ["foo:exception"]) { raise "lolwut" }
          end
          expected_message = "foobar:0|ms|#foo:exception"
          server.gets(expected_message.bytesize).should eq expected_message
        end
      end
    end
  end

  describe "#set" do
    it "should format the message according to the statsd spec" do
      with_server do |server, statsd|
        statsd.set("foobar", 1)
        expected_message = "foobar:1|s"
        server.gets(expected_message.bytesize).should eq expected_message
      end
    end

    it "should format the message according to the extended statsd spec" do
      with_server do |server, statsd|
        statsd.set("foobar", 1, tags: ["foo:bar"])
        expected_message = "foobar:1|s|#foo:bar"
        server.gets(expected_message.bytesize).should eq expected_message
      end
    end
  end

  describe "#histogram" do
    it "should format the message according to the statsd spec" do
      with_server do |server, statsd|
        statsd.histogram("foobar", 50)
        expected_message = "foobar:50|h"
        server.gets(expected_message.bytesize).should eq expected_message
      end
    end

    it "should raise an exception for negative values" do
      with_server do |server, statsd|
        expect_raises(Exception) { statsd.histogram("foobar", -50) }
      end
    end

    it "should format the message according to the extended statsd spec" do
      with_server do |server, statsd|
        statsd.histogram("foobar", 50, tags: ["foo:bar"])
        expected_message = "foobar:50|h|#foo:bar"
        server.gets(expected_message.bytesize).should eq expected_message
      end
    end
  end

  describe "#distribution" do
    it "should format the message according to the statsd spec" do
      with_server do |server, statsd|
        statsd.distribution("foobar", 50)
        expected_message = "foobar:50|d"
        server.gets(expected_message.bytesize).should eq expected_message
      end
    end

    it "should raise an exception for negative values" do
      with_server do |server, statsd|
        expect_raises(Exception) { statsd.distribution("foobar", -50) }
      end
    end

    it "should format the message according to the extended statsd spec" do
      with_server do |server, statsd|
        statsd.distribution("foobar", 50, tags: ["foo:bar"])
        expected_message = "foobar:50|d|#foo:bar"
        server.gets(expected_message.bytesize).should eq expected_message
      end
    end
  end
end
