# Change Log

All notable changes to this project will be documented in this file.
This project aims to adhere to [Semantic Versioning](http://semver.org/).

## 0.4.0 / 2022-04-24

- Added `Statsd::Client.distribution(metric_name, value, tags)` for Datadog compatibility

## 0.3.0 / 2021-04-11

- Crystal 0.35.1 removed Errno, so was removed in code as well #15
- Update to support Crystal 1.0.0 #16
- Minor doc tweaks

## 0.2.0 / 2020-03-14

- Crystal 0.34.0 replaced the Error condition <https://github.com/crystal-lang/crystal/pull/8885>
- **Breaking** Crystal 0.20.3 stopped automatic client hostname resolution, requiring a full IP address
- Feature: Emit timing from a block even if raised
- (Internal) Update MetricMessage to support Crystal 0.16.0
- (Internal) Replace MetricMessage struct creation with serializer
- (Internal) Use the `Number::Primitive` from Crystal 0.17.0
- Minor doc updates

## 0.1.0 / 2016-04-01

- Initial release, supporting all statsd spec & extended spec for histograms and tags.
