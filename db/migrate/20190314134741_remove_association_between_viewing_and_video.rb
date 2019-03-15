class RemoveAssociationBetweenViewingAndVideo < ActiveRecord::Migration[5.2]
  def change
    remove_index :viewings, :video_id
    remove_column :viewings, :video_id
  end
end
