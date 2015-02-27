
module Parsenip
  module Detection
    class Dictionary < Parsenip::Detection::Column
      attr_accessor :options
      attr_accessor :ticker
      attr_accessor :file
      def initialize(file, options = {})
        @file = file
        @options = options
        @ticker = {}
      end
      def match
        SmarterCSV.process(file.path, {chunk_size: 300, remove_empty_values: false}) do |chunk|
          chunk.each do |hash|   # you can post-process the data from each row to your heart's content, and also create virtual attributes:
            tick(hash)
          end
        end
        @ticker
      end
      def tick(hash)
        hash.each_pair do |key, value|
          type = Parsenip::Detection::WordMatcher.new(value).match
          if type
            @ticker[type] ||= {}
            # For debugging, push value on instead of a counter
            #@ticker[type][key] ||= []
            #@ticker[type][key].push value


            @ticker[type][key] ||= 0
            @ticker[type][key] += 1
          end
        end
      end
    end
  end
end

