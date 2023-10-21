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
#   "initial" => "Initial status", 
#      "paid" => "Payment processed", 
#     "error" => "Payment error"
# }



```

### Dehumanize Enum Values

The `dehumanize_enum` method lets you find an enum key based on its human-readable form:

```ruby
str = 'Payment error'
Payment.dehumanize_enum(:status, str) # => "error"

# or nil if the label does not correspond to a translation:
Payment.dehumanize_enum(:status, 'blah') # => nil 
```

### Advanced Usage

#### Translating Enums and Polymorphic Associations

This gem isn't just for enums; you can also use it to translate polymorphic association types. Here's how you can do it:

Let's consider a model `Document` with an enum field `status` and a polymorphic association called `documentable`:

```ruby
class Document < ApplicationRecord
  enum status: { draft: 0, published: 1, archived: 2 }
  belongs_to :documentable, polymorphic: true
end
```

And we have various models that include a concern `Documentable`:

```ruby

module Documentable
  extend ActiveSupport::Concern
  included do
    has_many :documents, as: :documentable
  end
end

class Article < ApplicationRecord
  include Documentable
end

class Report < ApplicationRecord
  include Documentable
end
```

In your locale files, you can set translations for both the enum `status` and the polymorphic association type `documentable_type`:

```yaml
en:
  activerecord:
    attributes:
      document:
        status: "Status"
        status/draft: "Draft"
        status/published: "Published"
        status/archived: "Archived"
        documentable_type: "Type"
        documentable_type/article: "Article"
        documentable_type/report: "Report"
```

Now you can use `humanize_enum` to get these translations:

```ruby
document = Document.last
document.status # => :published
document.humanize_enum(:status) # => 'Published'

document.documentable_type # => 'Article'
document.humanize_enum(:documentable_type) # => 'Article'
```

And to query a translation for a specific value:

```ruby
Document.humanize_enum(:status, :archived) # => 'Archived'
Document.humanize_enum(:documentable_type, :article) # => 'Article'
```

To get the actual enum or polymorphic type from a human-readable string:

```ruby
Document.dehumanize_enum(:status, 'Published') # => :published
Document.dehumanize_enum(:documentable_type, 'Article') # => :article
```


## Inspired by

- a post by [Juraj Kostolanský](https://www.kostolansky.sk/posts/localize-rails-enums/) and
  his [gem](https://github.com/jkostolansky/human_enum_name)
- i18n keys lookup approach of [aasm i18n support](https://github.com/aasm/aasm/wiki/I18n-support)

## Alternatives

- [human_enum_name](https://github.com/jkostolansky/human_enum_name)
- [ar_enum_i18n](https://github.com/dalpo/ar_enum_i18n)
- [translate_enum](https://github.com/shlima/translate_enum)

## Why Another Gem for Enum I18n?

You might be wondering, "Why create another gem for internationalizing enums when there are already alternatives?"

Here are some reasons why `humanize_enum` might be the right choice for you:

1. **Not Just for Enums**: Yeah, it's called `humanize_enum`, but you can totally use it for polymorphic associations too. Neat, right?

2. **Fast and Light**: We've trimmed the fat to make sure this gem runs smoothly, without slowing down your app.

3. **No Rocket Science**: Simple to get, simple to use. You don't need a Ph.D. to figure it out.

4. **Clean and Familiar Structure**: We keep your locale keys neat and tidy, like `status/paid`, and it's kinda similar to what you see in other gems like AASM. So, less headache for you.




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
