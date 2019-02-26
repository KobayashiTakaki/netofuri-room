class RenameVideoSetsColumn < ActiveRecord::Migration[5.2]
  def change
    rename_column :video_sets, :type, :video_type
  end
end
