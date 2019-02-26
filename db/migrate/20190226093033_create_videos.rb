class CreateVideos < ActiveRecord::Migration[5.2]
  def change
    create_table :videos do |t|
      t.integer :netflix_id
      t.integer :season
      t.integer :episode
      t.integer :runtime
      t.belongs_to :video_set, index: true

      t.timestamps
    end
  end
end
