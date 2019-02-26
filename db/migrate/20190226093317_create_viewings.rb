class CreateViewings < ActiveRecord::Migration[5.2]
  def change
    create_table :viewings do |t|
      t.datetime :start_time
      t.datetime :end_time
      t.belongs_to :room, index: true
      t.belongs_to :video, index: true

      t.timestamps
    end
  end
end
