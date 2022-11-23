# Humanize Enum

Enhanced I18n support for ActiveRecord Enums.

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add humanize_enum

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install humanize_enum

## Usage

Declare your enums:

```ruby
class Payment < ActiveRecord::Base
  enum status: {initial: 0, paid: 1, error: 2}
end
```

Add enum values to locale files:
```yaml
en:
  activerecord:
    attributes:
      payment:
        status: Status
        status/initial: Initial status
        status/paid: Payment processed
        status/error: Payment error
```

And now the translation is available in every place you need it:

```ruby
payment = Payment.last
payment.status # => :paid
payment.humanize_enum(:status) # => 'Payment processed'
```

And to query a translation for a specific value
```ruby
Payment.humanize_enum(:status, :error) # => 'Payment error'
```

To get a hash of available enums and their translations
```ruby
Payment.humanize_enums(:status)
payment.humanize_enums(:status)  
# both will return
# {
#   initial: 'Initial status', 
#   paid:    'Payment processed', 
#   error:   'Payment error'
# }



```

## Inspired by

- a post by [Juraj Kostolanský](https://www.kostolansky.sk/posts/localize-rails-enums/) and
  his [gem](https://github.com/jkostolansky/human_enum_name)
- i18n keys lookup approach of [aasm i18n support](https://github.com/aasm/aasm/wiki/I18n-support)

## Alternatives

- [human_enum_name](https://github.com/jkostolansky/human_enum_name)
- [ar_enum_i18n](https://github.com/dalpo/ar_enum_i18n)
- [translate_enum](https://github.com/shlima/translate_enum)

## TODO
- check input parameters for presence in enums
- add some specs?
- maybe some justification on why on earth make yet another gem on enum i18n  

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can
also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the
version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version,
push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/austerlitz/humanize_enum. This project is
intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to
the [code of conduct](https://github.com/austerlitz/humanize_enum/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the HumanizeEnum project's codebases, issue trackers, chat rooms and mailing lists is expected
to follow the [code of conduct](https://github.com/austerlitz/humanize_enum/blob/master/CODE_OF_CONDUCT.md).
