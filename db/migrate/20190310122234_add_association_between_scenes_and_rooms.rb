class AddAssociationBetweenScenesAndRooms < ActiveRecord::Migration[5.2]
  def change
    add_reference :scenes, :room, index: true
  end
end
