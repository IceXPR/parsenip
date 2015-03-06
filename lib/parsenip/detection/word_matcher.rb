module Parsenip
  module Detection
    class WordMatcher
      attr_accessor :word
      def initialize(word)
        @word = word.to_s.strip
      end
      def match
        return if @word.nil?
        check_methods.each do |method|
          if send(method)
            return method
          end
        end
        # Type not found
        nil
      end
      def is_first_name
        matches_by_type 'first_names'
      end
      def is_last_name
        matches_by_type 'last_names'
      end
      # If we find "{first_name} {any_amount_of_letters}", we'll call it a full name
      def is_full_name
        ::Dictionary.first_names.each do |first_name|
          if @word.match /^#{first_name.value} [A-Za-z]/i
            return true
          end
        end
        false
      end
      def matches_by_type(type)
        ::Dictionary.send(type).each do |dictionary_word|
          if @word == dictionary_word.value
            return true
          end
        end
        false
      end
      def is_zipcode
        @word.match(/^[0-9]{5}(-[0-9]{4})?$/)
      end
      def is_phone
        return false if is_zipcode
        clean_phone = @word.gsub(/[^0-9]/, '')

        if clean_phone.length == 7 or clean_phone.length == 10 or clean_phone.length == 11
          return true
        end
        false
      end
      def is_email
        # Very simple email matching.
        @word.match(/\w+@\w+/)
      end
      private
      def check_methods
        [:is_phone, :is_email, :is_first_name, :is_last_name, :is_full_name]
      end
    end
  end
end
