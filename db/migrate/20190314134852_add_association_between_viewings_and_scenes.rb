class AddAssociationBetweenViewingsAndScenes < ActiveRecord::Migration[5.2]
  def change
    add_reference :viewings, :scene, index: true
  end
end
