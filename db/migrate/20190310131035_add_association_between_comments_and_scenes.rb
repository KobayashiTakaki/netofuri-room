class AddAssociationBetweenCommentsAndScenes < ActiveRecord::Migration[5.2]
  def change
    add_reference :comments, :scene, index: true
  end
end
