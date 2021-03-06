class CreateJoinings < ActiveRecord::Migration[5.2]
  def change
    create_table :joinings do |t|
      t.belongs_to :user, index: true
      t.belongs_to :viewing, index: true
      t.index [:user_id, :viewing_id], unique: true

      t.timestamps
    end
  end
end
