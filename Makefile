.PHONY: all build clean format spec release

all: build

build:
	crystal build --stats -o bin/statsd src/statsd.cr

clean:
	rm -fr .crystal/ bin/statsd

format:
	crystal tool format

spec:
	crystal spec

release: clean
	crystal build --stats -o bin/statsd --release src/statsd.cr
