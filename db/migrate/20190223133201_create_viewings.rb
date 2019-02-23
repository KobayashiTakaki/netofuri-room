class CreateViewings < ActiveRecord::Migration[5.2]
  def change
    create_table :viewings do |t|
      t.integer :start_time
      t.datetime :started_at
      t.boolean :active
      t.belongs_to :room, index: true
      t.belongs_to :video, index: true

      t.timestamps
    end
  end
end
