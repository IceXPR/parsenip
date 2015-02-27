
class DataGrabberService
  attr_accessor :upload, :headers
  def initialize(headers, upload)
    @upload = upload
    @headers = headers
  end

  def start
    SmarterCSV.process(@upload.file.path, {chunk_size: 300, remove_empty_values: false}) do |chunk|
      chunk.each do |hash|
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
        end
        parsed.save
      end
    end
  end
end

