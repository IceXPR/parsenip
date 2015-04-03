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
        chunk_size = 100
        @upload.update_attributes(total_chunks: (BigDecimal(@upload.lines) / BigDecimal(chunk_size)).ceil)

        SmarterCSV.process(@file.path, {chunk_size: chunk_size, remove_empty_values: false, row_sep: :auto}) do |chunk|
          if @upload.lines < chunk_size
            process_whole_chunk(chunk)
          else
            sample_chunk(chunk)
          end
          @upload.update_progress_from_dictionary
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

      def process_whole_chunk(chunk)
        chunk.each do |line|
          tick(line)
        end
        @upload.update_attributes(processed_chunks: @upload.processed_chunks += 1)
      end

      def sample_chunk(chunk)
        tick(chunk.sample)
        @upload.update_attributes(processed_chunks: @upload.processed_chunks += 1)
      end
    end
  end
end

