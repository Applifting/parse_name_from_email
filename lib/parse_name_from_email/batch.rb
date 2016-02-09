module ParseNameFromEmail
  class Batch
    class << self
      def split_emails_to_array(string_with_emails)
        string_with_emails.split(/\;|\,/)
      end
    end
  end
end
