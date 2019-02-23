class CreateRooms < ActiveRecord::Migration[5.2]
  def change
    create_table :rooms do |t|
      t.belongs_to :user, index: true

      t.timestamps
    end
  end
end
