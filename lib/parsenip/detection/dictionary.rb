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
        update_rate = 10
        chunk_size = 100
        # chunk_size = Upload.uploader_chunk_size
        position = 0
        SmarterCSV.process(@file.path, {chunk_size: chunk_size, remove_empty_values: false, row_sep: :auto}) do |chunk|
          if @upload.lines < chunk_size
            process_whole_chunk(chunk, position, update_rate)
          else
            sample_chunk(chunk)
          end
          puts "Ticker #{@ticker.inspect}"
        end
        puts "Ticker #{@ticker.inspect}"

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

      def process_whole_chunk(chunk, position, update_rate)
        chunk.each do |line|
          tick(line)
          position += 1
          if position % update_rate == 0
            puts "***Updating Progress @ #{position}"
            @upload.update_progress_from_position(position)
          end
        end
      end

      def sample_chunk(chunk)
        tick(chunk.sample)
        puts "#{(chunk.size + (@upload.progress || 0))}"
      end
    end
  end
end

