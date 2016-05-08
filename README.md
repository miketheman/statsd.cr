# statsd.cr

A [statsd](https://github.com/etsy/statsd) client library for [Crystal](http://crystal-lang.org/).

[![Build Status](https://travis-ci.org/miketheman/statsd.cr.svg?branch=master)](https://travis-ci.org/miketheman/statsd.cr)

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  statsd:
    github: miketheman/statsd.cr
```


## Usage

```crystal
require "statsd"

statsd = Statsd::Client.new
statsd.increment "myapp.login_page", 1

# Datadog-compliant statsd tags:
statsd.increment "page.views", tags: ["page:login", "app:myapp"]
```

See `examples/test.cr` for more.


## Contributing

1. [Fork it](https://github.com/miketheman/statsd.cr/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Test your changes with `make spec`
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create a new Pull Request


## Contributors
Inspired by [syslog.cr](https://github.com/comandeo/syslog.cr) and [statsd](https://github.com/reinh/statsd).

- [@miketheman](https://github.com/miketheman) Mike Fiedler - creator, maintainer
