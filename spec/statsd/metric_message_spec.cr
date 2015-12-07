require "../spec_helper"

describe Statsd::MetricMessage do
  context "base protocol" do
    it "supports #gauge" do
      io = MemoryIO.new
      message = Statsd::MetricMessage.new("users.current", 20, "g")
      message.to_s(io)
      io.to_s.should eq("users.current:20|g")
    end

    it "supports #counter (Int32)" do
      io = MemoryIO.new
      message = Statsd::MetricMessage.new("page.views", 1, "c")
      message.to_s(io)
      io.to_s.should eq("page.views:1|c")
    end

    it "supports #counter (Float)" do
      io = MemoryIO.new
      message = Statsd::MetricMessage.new("page.views", 1.3, "c")
      message.to_s(io)
      io.to_s.should eq("page.views:1.3|c")
    end

    it "supports #counter, @sampled (Int32)" do
      io = MemoryIO.new
      message = Statsd::MetricMessage.new("page.views", 1, "c", 0.5)
      message.to_s(io)
      io.to_s.should eq("page.views:1|c|@0.5")
    end

    it "supports #counter, @sampled (Float)" do
      io = MemoryIO.new
      message = Statsd::MetricMessage.new("page.views", 1.3, "c", 0.3)
      message.to_s(io)
      io.to_s.should eq("page.views:1.3|c|@0.3")
    end
  end
end
