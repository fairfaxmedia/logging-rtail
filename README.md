# Logging::Plugins::Rtail

This is an "Appender" for the [Logging](https://rubygems.org/gems/logging) gem, to allow you to forward Logs directly to an
[Rtail](https://github.com/kilianc/rtail) Service.

Normally, you'd use the Rtail client to read logs from another process (e.g. `tail -F process.log | rtail --name WildTest`) but
this Gem allows you to send the logs directly.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'logging'
gem 'logging-rtail'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install logging-rtail

## Usage

The Logging gem uses [little-plugger](https://rubygems.org/gems/little-plugger) gem to manage
[extending Logger](https://github.com/TwP/logging#extending).
This means it will automatically load and initialise the `logging-rtail` code as soon as it loads the Logging code.

To configure Logging to use Rtail, you simply have to add the appender to your configuring of Logging.

e.g. The following will send the "Wootles" log-output to STDERR and the Rtail service running on the localhost:

```ruby
l = Logging.logger["The Wild Wild Test"]
l.add_appenders(
  Logging.appenders.stderr,
  Logging.appenders.rtail("Wild Test stream")
)

l.info "Wootles"
```

The default host is `localhost` and port is `9999`, as per [Rtail's defaults](https://github.com/kilianc/rtail#params-1).

If you want to connect to an Rtail service on a different host or port, pass the `host` or `port` options to the `rtail` appender factory:

```ruby
l.add_appenders(
  Logging.appenders.rtail("Wild Test stream", host: "other.host.nowhere", port: 10010)
)
```

### Omitting Timezone from the Timestamp

The Rtail server seems to output Timestamps in UTC uncomprimisingly, rather than localtime.
This can make it a little confusing when watching the logs if you don't live in the UK.

As a work-around, you can enable the option `omit_timezone` to the Rtail appender, and it will drop
TZ information from the Timestamp it sends to the Rtail server:

```ruby
l.add_appenders(
  Logging.appenders.rtail("Wild Test stream", omit_timezone: true)
)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests.
You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in
`lib/logging/plugins/rtail.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits
and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

### To Do's

I track major "To Do's" in a [TODO.org](TODO.org) file.

I track context-sensitive and minor ones with `TODO` and `FIXME` comments in the source code.

### Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/fairfaxmedia/logging-rtail.
