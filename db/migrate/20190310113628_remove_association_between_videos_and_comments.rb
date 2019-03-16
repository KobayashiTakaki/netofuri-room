class RemoveAssociationBetweenVideosAndComments < ActiveRecord::Migration[5.2]
  def change
    remove_index :comments, :video_id
    remove_column :comments, :video_id
  end
end
