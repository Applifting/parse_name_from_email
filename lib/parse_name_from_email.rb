require 'active_support/all'

require 'parse_name_from_email/version'
require 'parse_name_from_email/configuration'
require 'parse_name_from_email/batch'

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

    # parses string of multiple emails to hash of emails and generated names
    def parse_emails_with_names_from(string_with_emails)
      emails = Batch.split_emails_to_array(string_with_emails)
      result = {}
      emails.each { |email| result[get_email_address(email)] = parse_name_from(email) }
      result
    end

    # parses string of multiple emails to array of names
    def parse_names_from(string_with_emails)
      emails = Batch.split_emails_to_array(string_with_emails)
      result = []
      emails.each { |email| result << parse_name_from(email) }
      result
    end

    # main logic of parsing one email address
    def parse_name_from(email)
      # if emails is in RFC format, return the name if not blank
      name_from_rfc = get_name_if_rfc_format_of_email(email)
      return name_from_rfc unless name_from_rfc.blank?

      # get part before '@'
      email_name = get_email_name(email)

      splitted_by_plus = split_plus_part(email_name) # get part before and after plus part

      # if friendly plus part, make result more readable
      if splitted_by_plus.size >= 2
        email_name = splitted_by_plus[0...-1].join(' ') # reject part after plus and overwrite it joined to string
        if configuration.friendly_plus_part
          plus_part = splitted_by_plus.last # last part is after plus and it should be gmail nickname
        end
      end

      splitted_email = split_to_words(email_name) # split email name by regex

      name = make_human_readable(splitted_email) # join email name with space

      # add part after plus
      if configuration.friendly_plus_part && !plus_part.blank?
        name += ' ' unless name.blank?
        name += "(#{plus_part})" unless plus_part.blank?
      end

      name # return result
    end

    # split email by '@' and get only email name
    def get_email_name(email)
      email.split('@').first
    end

    # is rfc format? if true, return me only the email address
    def get_email_address(email)
      if valid_rfc_format?(email)
        email = email.split(/\</).last.to_s.delete('>')
      end
      email.strip
    end

    # if is rfc format of email, returns only name
    def get_name_if_rfc_format_of_email(email)
      name = email.split(/\</).first.to_s.strip if valid_rfc_format?(email)
      name
    end

    # split email plus part
    def split_plus_part(email)
      email.split('+')
    end

    # split email by regex
    def split_to_words(email_name)
      email_name.split(configuration.regexp)
    end

    # after regex join it with blank space and upcase first letters
    def make_human_readable(array)
      humanized_elements = array.map { |el| el.strip.humanize }
      humanized_elements.reject(&:empty?).reject{ |str| str =~ /\d/ }.join(' ')
    end

    # match regexp if is valid rfc format
    def valid_rfc_format?(email)
      match = (email =~ Configuration.regex_for_validation_format_as_rfc)
      match.present?
    end
  end
end
