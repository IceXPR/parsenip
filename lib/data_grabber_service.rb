
class DataGrabberService
  attr_accessor :upload, :headers
  def initialize(headers, upload)
    @upload = upload
    @headers = headers
  end

  def start
    # Make sure the progress indicates 50% at this point
    @upload.set_halfway_complete

    chunk_size = 250
    position = 0
    SmarterCSV.process(@upload.file.path, {keep_original_headers: true, chunk_size: chunk_size, remove_empty_values: false}) do |chunk|
      does_have_headers = HeaderMatch.has_headers?(chunk[0].keys)
      chunk.each do |hash|
        puts "Has Headers: #{does_have_headers}"
        parsed = @upload.parse_data.new
        @headers.each do |type, col|
          model_column = type.to_s.gsub(/^is_/, '')

          if model_column == "full_name"
            # TODO: This won't work with middle initials/names
            name = hash[col].split(/ /)
            parsed.first_name = name[0]
            parsed.last_name = name[1]
          else
            parsed[model_column] = hash[col]
          end
          position += 1
        end
        parsed.save
      end
      @upload.update_progress_on_parse_data(position)
    end
  end
end

