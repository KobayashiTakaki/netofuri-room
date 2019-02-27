class AddAssociationBetweenRoomAndVideoSet < ActiveRecord::Migration[5.2]
  def change
    add_reference :video_sets, :room, index: true
  end
end
