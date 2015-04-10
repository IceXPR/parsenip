class CreateCompletedChunks < ActiveRecord::Migration
  def change
    create_table :completed_chunks do |t|
      t.references :upload
      t.timestamps null: false
    end
  end
end
