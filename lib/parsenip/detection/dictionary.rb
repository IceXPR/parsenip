module Parsenip
  module Detection
    class Dictionary < Parsenip::Detection::Column
      attr_accessor :options
      attr_accessor :ticker
      attr_accessor :upload
      attr_accessor :file
      def initialize(upload, options = {})
        @upload = upload

        default_options = {number_of_lines: nil}
        @options = default_options.merge(options)

        @ticker = {}
      end

      def match
        @upload.iterate_lines(@options[:number_of_lines]) do |chunk|
          process_whole_chunk(chunk)
          puts "Ticker #{@ticker.inspect}"
        end
        puts "Final Ticker #{@ticker.inspect}"

        @ticker
      end

      def tick(hash)
        hash.each_with_index do |hashpair, column|
          value = hashpair[1] # value is stored at 1, i.e. [:column_name, "somevalue"] on each_with_index
          type = Parsenip::Detection::WordMatcher.new(value).match
          puts "Detected type: #{type} for value #{value}"
          if type
            @ticker[type] ||= {}
            @ticker[type][column] ||= 0
            @ticker[type][column] += 1
          end
        end
      end

      def process_whole_chunk(chunk)
        chunk.each do |line|
          tick(line)
        end
      end

    end
  end
end

