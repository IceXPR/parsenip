
module Parsenip
  module Detection
    class Dictionary < Parsenip::Detection::Column
      attr_accessor :options
      attr_accessor :ticker
      attr_accessor :upload
      attr_accessor :file
      def initialize(upload, options = {})
        @upload = upload
        @file = @upload.file
        @options = options
        @ticker = {}
      end
      def match
        chunk_size = 250
        position = 0
        SmarterCSV.process(@file.path, {chunk_size: chunk_size, remove_empty_values: false}) do |chunk|
          chunk.each do |hash|
            tick(hash)
            position += 1
          end
          @upload.update_progress_from_position(position)
        end
        @ticker
      end
      def tick(hash)
        hash.each_pair do |key, value|
          type = Parsenip::Detection::WordMatcher.new(value).match
          if type
            @ticker[type] ||= {}
            @ticker[type][key] ||= 0
            @ticker[type][key] += 1
          end
        end
      end
    end
  end
end

