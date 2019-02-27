class VideoSet < ApplicationRecord
  belongs_to :room
  has_many :videos, dependent: :destroy

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      video_set = find_by(netflix_id: row["netflix_id"])
      video_set = new unless video_set

      # CSVからデータを取得し、設定する
      video_set.attributes = row.to_hash.slice(*updatable_attributes)
      video_set.save!
    end
  end

  def self.updatable_attributes
    ["netflix_id", "title", "video_type"]
  end
end
