class CreateVideos < ActiveRecord::Migration[5.2]
  def change
    create_table :videos do |t|
      t.string :netflix_id
      t.integer :runtime

      t.timestamps
    end
  end
end
