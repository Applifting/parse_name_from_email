# ParseNameFromEmail

[![Gem Version](https://badge.fury.io/rb/parse_name_from_email.svg)](https://badge.fury.io/rb/parse_name_from_email)
[![Build Status](https://travis-ci.org/Applifting/parse_name_from_email.svg?branch=master)](https://travis-ci.org/Applifting/parse_name_from_email)
[![Coverage Status](https://coveralls.io/repos/github/Applifting/parse_name_from_email/badge.svg?branch=master)](https://coveralls.io/github/Applifting/parse_name_from_email?branch=master)

Rails gem to easily parse user name from email address.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'parse_name_from_email'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install parse_name_from_email

## Configuration

You don't need to configure anything, but if you want to customize the behaviour, use the following snippet:

```ruby
ParseNameFromEmail.configure do |config|
  # split email address with regexp
  config.regexp = /(?=[A-Z])|(?:([0-9]+))|\.|-|\?|!|\+|\;|\_/

  ## Recognizing plus parts in gmail addresses
  #
  # DEFAULT: true
  #
  # if TRUE:
  #   email address:  'example+something123@gmail.com'
  #   result name:    'Example (Something 123)'
  #
  # if FALSE:
  #   email address:  'example+something123@gmail.com'
  #   result name:    'Example'
  config.friendly_plus_part = true
end
```

Values in the above snippet are the default values.

## Usage

```ruby
# getting email address
ParseNameFromEmail.get_email_name('john-snow@example.com') # => 'john-snow'
ParseNameFromEmail.get_email_name('john-snow+nickname@example.com') # => 'john-snow+nickname'

# parsing name from email address
ParseNameFromEmail.parse_name_from('JohnSnow@example.com') # => 'John Snow'
ParseNameFromEmail.parse_name_from('john-snow@example.com') # => 'John Snow'
ParseNameFromEmail.parse_name_from('john_snow@example.com') # => 'John Snow'
ParseNameFromEmail.parse_name_from('john123snow@example.com') # => 'John Snow'
ParseNameFromEmail.parse_name_from('John Snow <john.snow@example.com>') # => 'John Snow'

# validating RFC format of email
ParseNameFromEmail.valid_rfc_format?('john-snow@example.com') # => false
ParseNameFromEmail.valid_rfc_format?('John Snow <john.snow@example.com>') # => true

# if config.friendly_plus_part = true
ParseNameFromEmail.parse_name_from('JohnSnow+Nickname123@example.com') # => 'John Snow (Nickname 123)'

# if config.friendly_plus_part = false
ParseNameFromEmail.parse_name_from('JohnSnow+Nickname123@example.com') # => 'John Snow'

# batches
string_with_emails = 'John Snow <john.snow@example.com>, alice.123@3x4mpl3.app'
ParseNameFromEmail.parse_names_from(string_with_emails) # => ['John Snow', 'Alice']

string_with_emails = 'lily+black@example.com, alice.123@3x4mpl3.app'
ParseNameFromEmail.parse_names_from(string_with_emails) # => ['Lily (black)', 'Alice']

# advanced parsing
string_with_emails = 'john.snow@example.com, lily+black@example.com'
ParseNameFromEmail.parse_emails_with_names_from(string_with_emails)
# => {'john.snow@example.com' => 'John Snow', 'lily+black@example.com' => 'Lily (black)'}

```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Applifting/parse_name_from_email.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

