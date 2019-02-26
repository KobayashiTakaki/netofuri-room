class CreateVideoSets < ActiveRecord::Migration[5.2]
  def change
    create_table :video_sets do |t|
      t.integer :netflix_id
      t.string :title
      t.string :type

      t.timestamps
    end
  end
end
