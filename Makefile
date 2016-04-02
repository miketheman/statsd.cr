.PHONY: all benchmark clean docs format spec release

all: spec

benchmark: clean
	crystal run --release examples/benchmark.cr

clean:
	rm -fr .crystal/ doc/ bin/*

docs:
	crystal docs

format:
	crystal tool format

spec:
	crystal spec

release: clean
	# TODO: shards release
