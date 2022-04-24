require "../spec_helper"

describe Statsd::MetricMessage do
  context "base protocol" do
    it "supports #gauge" do
      message = Statsd::MetricMessage.serialize_metric("users.current", 20, "g")
      message.should eq("users.current:20|g")
    end

    it "supports #distribution" do
      message = Statsd::MetricMessage.serialize_metric("request.latency", 20.0442, "d")
      message.should eq("request.latency:20.0442|d")
    end

    it "supports #counter (Int32)" do
      message = Statsd::MetricMessage.serialize_metric("page.views", 1, "c")
      message.should eq("page.views:1|c")
    end

    it "supports #counter (Float)" do
      message = Statsd::MetricMessage.serialize_metric("page.views", 1.3, "c")
      message.should eq("page.views:1.3|c")
    end

    it "supports #counter, @sampled (Int32)" do
      message = Statsd::MetricMessage.serialize_metric("page.views", 1, "c", 0.5)
      message.should eq("page.views:1|c|@0.5")
    end

    it "supports #counter, @sampled (Float)" do
      message = Statsd::MetricMessage.serialize_metric("page.views", 1.3, "c", 0.3)
      message.should eq("page.views:1.3|c|@0.3")
    end
  end

  context "extended protocol: tags" do
    it "supports #gauge, @tag" do
      message = Statsd::MetricMessage.serialize_metric("users.current", 20, "g", tags: ["app:foo"])
      message.should eq("users.current:20|g|#app:foo")
    end

    it "supports #gauge, @tags" do
      message = Statsd::MetricMessage.serialize_metric("users.current", 20, "g", tags: ["app:foo", "host:bar"])
      message.should eq("users.current:20|g|#app:foo,host:bar")
    end
  end
end
