class CreateScenes < ActiveRecord::Migration[5.2]
  def change
    create_table :scenes do |t|
      t.string :title
      t.integer :start_time
      t.integer :end_time
      t.belongs_to :video, index: true

      t.timestamps
    end
  end
end
