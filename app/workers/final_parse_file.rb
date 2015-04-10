class FinalParseFile
  include Sidekiq::Worker

  def perform(chunk, upload_id, headers)
    # ActiveRecord::Base.connection.execute('set statement_timeout to 15000')
    headers = JSON.parse(headers).with_indifferent_access
    upload = Upload.find(upload_id)
    chunk.each do |line|
      parsed = upload.parse_data.new
      each_parsed_header_match(headers, parsed, line).save
    end
    puts '*** FINISHED CHUNK ***'
    upload.completed_chunks.create()
    upload.update_progress_from_data_grabber
  end

  private

  def each_parsed_header_match headers, parsed, line
    headers.each do |type, col|
      model_column = type.to_s.gsub(/^is_/, '')

      if model_column == "full_name"
        # TODO: This won't work with middle initials/names
        name = line[col].to_s.split(/ /)
        parsed.first_name = name[0]
        parsed.last_name = name[1]
      else
        parsed[model_column] = line[col]
      end
    end
    return parsed
  end
end