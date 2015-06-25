

class GatherChunkData
  include Sidekiq::Worker
  def perform(upload_id, chunk)
    upload = Upload.find(upload_id)

    # Organize the assigned column data
    columns = []
    upload.assigned_columns.ordered.each do |ac|
      columns.push(ac.column_id ? ac.column.key : nil)
    end

    chunk.each do |line|
      contact = {}
      line.each_with_index do |item, i|
        if columns[i]
          contact[columns[i]] = item[1]
        end
      end
      # All columns assigned!  Create the contact!
      upload.parse_data.create(contact)
    end

    puts "#{upload.parse_data.count} vs #{upload.lines}"

    if upload.parse_data.count >= upload.lines and ! upload.data_sent
      # All contacts have been created - go ahead and send the data back to the client server.
      SendParseData.perform_async(upload.id)
    end
  end
end

