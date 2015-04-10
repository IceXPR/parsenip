
class DataGrabberService
  attr_accessor :upload, :headers
  def initialize(headers, upload)
    @upload = upload
    @headers = headers
  end

  def start
    # Make sure the progress indicates 50% at this point
    @upload.header_match_offset
    chunk_size = 300
    #reset count for second round of processing
    @upload.update_attributes(total_chunks: (BigDecimal(@upload.lines) / BigDecimal(chunk_size)).ceil)
    number_of_chunks = SmarterCSV.process(@upload.file.path, {chunk_size: chunk_size, remove_empty_values: false, row_sep: :auto}) do |chunk|
      FinalParseFile.perform_async(chunk, @upload.id, headers.to_json)
    end
  end

end

