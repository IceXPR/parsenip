class AddChunkDataToUploads < ActiveRecord::Migration
  def change
    add_column :uploads, :total_chunks, :integer, default: 0
    add_column :uploads, :processed_chunks, :integer, default: 0
  end
end
