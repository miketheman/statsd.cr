require "../src/statsd.cr"

# Run these examples with an associated statsd server to see the format.
# There is a sample Statsd server in this folder, see `server.rb`.

statsd = Statsd::Client.new

5.times do
  statsd.increment "page.views", tags: ["page:home"]
end

5.times do
  statsd.decrement "page.views"
end

5.times do
  statsd.gauge("users.current", Random.rand(20))
end

5.times do
  statsd.timing("db.query", Random.rand(500))
end

5.times do
  statsd.time("block.timed.random_sleep") { sleep "0.#{Random.rand(5)}".to_f }
end

5.times do
  statsd.histogram("database.query.time", Random.rand(500))
end
