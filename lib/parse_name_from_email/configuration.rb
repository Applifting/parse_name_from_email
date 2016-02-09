module ParseNameFromEmail
  class Configuration
    attr_accessor :regex, :friendly_plus_part

    def initialize
      # split email address with regex
      @regex = /(?=[A-Z])|(?:([0-9]+))|\.|-|\?|!|\+|\;|\_/

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

  end
end