require "benchmark"
require "../src/statsd.cr"

Benchmark.ips do |x|
  statsd = Statsd::Client.new

  x.report("increments") { statsd.increment "page.views" }
  x.report("increments w/tags") { statsd.increment "page.views", tags: ["foo:bar"] }
  x.report("decrements") { statsd.decrement "page.views" }
  x.report("gauges") { statsd.gauge("users.current", 5) }
  x.report("gauges w/tags") { statsd.gauge("users.current", 5, tags: ["foo:bar"]) }
  x.report("timing") { statsd.timing("db.query", 100) }
  x.report("time") { statsd.time("timed.block") { true } }
end
