
class DataGrabberService
  attr_accessor :upload, :headers
  def initialize(headers, upload)
    @upload = upload
    @headers = headers
  end

  def start
    # Make sure the progress indicates 50% at this point
    @upload.header_match_offset
    chunk_size = 250
    position = 0
    SmarterCSV.process(@upload.file.path, {chunk_size: chunk_size, remove_empty_values: false, row_sep: :auto}) do |chunk|
      does_have_headers = HeaderMatch.has_headers?(chunk[0].keys)
      chunk.each do |hash|
        parsed = @upload.parse_data.new
        each_parsed_header_match(headers, upload, parsed, hash, position).save
        position += 1
      end
    end
  end

  private

  def each_parsed_header_match headers, upload, parsed, each_chunk, position
    headers.each do |type, col|
      model_column = type.to_s.gsub(/^is_/, '')

      if model_column == "full_name"
        # TODO: This won't work with middle initials/names
        name = each_chunk[col].to_s.split(/ /)
        parsed.first_name = name[0]
        parsed.last_name = name[1]
      else
        parsed[model_column] = each_chunk[col]
      end
      upload.update_progress_on_parse_data(position)
    end
    return parsed
  end
end

