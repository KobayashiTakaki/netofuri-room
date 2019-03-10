class RemoveAssociationBetweenVideoSetsAndRooms < ActiveRecord::Migration[5.2]
  def change
    remove_index :video_sets, :room_id
    remove_column :video_sets, :room_id
  end
end
