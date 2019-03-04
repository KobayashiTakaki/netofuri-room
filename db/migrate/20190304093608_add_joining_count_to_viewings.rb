class AddJoiningCountToViewings < ActiveRecord::Migration[5.2]
  def change
    add_column :viewings, :joinings_count, :integer, default: 0
  end
end
