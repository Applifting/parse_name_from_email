require 'active_support/all'

require 'parse_name_from_email/version'
require 'parse_name_from_email/configuration'

module ParseNameFromEmail
  class << self

    def configuration
      @configuration ||= Configuration.new
    end

    def reset
      @configuration = Configuration.new
    end

    def configure
      yield(configuration)
    end

    def parse_name_from(email)
      email_name = get_email_name(email)

      # if friendly plus part, make result more readable
      if configuration.friendly_plus_part
        splitted_by_plus = split_plus_part(email_name) # get part before and after plus part

        if splitted_by_plus.size >= 2
          email_name = splitted_by_plus[0...-1].join(' ') # reject part after plus and overwrite it joined to string
          plus_part = splitted_by_plus.last # last part is after plus and it should be gmail nickname
        else
          email_name = splitted_by_plus.join(' ')
        end
      end

      splitted_email = split_to_words(email_name) # split email name by regex

      name = make_human_readable(splitted_email) # join email name with space

      # add part after plus
      if configuration.friendly_plus_part && !plus_part.blank?
        name += " " unless name.blank?
        name += "(#{plus_part})" unless plus_part.blank?
      end

      name # return result
    end

    # split email by '@' and get only email name
    def get_email_name(email)
      email.split('@').first
    end

    # split email plus part
    def split_plus_part(email)
      email.split('+')
    end

    # split email by regex
    def split_to_words(email_name)
      email_name.split(configuration.regex)
    end

    # after regex join it with blank space and upcase first letters
    def make_human_readable(array)
      humanized_elements = array.map(&:humanize)
      humanized_elements.join(' ')
    end

  end
end
