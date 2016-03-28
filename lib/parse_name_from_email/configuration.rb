module ParseNameFromEmail
  class Configuration
    attr_accessor :regexp, :friendly_plus_part

    def initialize
      # split email address with regexp (test: https://regex101.com/r/pF5mS4)
      @regexp = /(?=[A-Z])|(?:([0-9]+))|\.|-|\?|!|\+|\;|\_/

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
      #   result name:    'Example Something 123'
      @friendly_plus_part = true
    end

    def self.regexp_to_split_by_rfc
      /(\<|\>)/
    end

    def self.regex_for_validation_format_as_rfc
      /(\<[\S]*[\S]*\.[\S]*\>)/
    end
  end
end
