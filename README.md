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
```


TODO: Write usage instructions here

## Development

TODO: Write development instructions here

## Contributing

1. Fork it ( https://github.com/[your-github-name]/statsd/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors
Leans heavily on [syslog.cr](https://github.com/comandeo/syslog.cr) and [statsd](https://github.com/reinh/statsd) for inspiration.

- [miketheman](https://github.com/miketheman) Mike Fiedler - creator, maintainer
