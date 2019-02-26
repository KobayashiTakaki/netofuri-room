class Video < ApplicationRecord
  belongs_to :video_set
  has_many :comments, dependent: :destroy

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      video = find_by(netflix_id: row["netflix_id"])
      video = new unless video

      video_set = VideoSet.find_by(netflix_id: row["video_sets_netflix_id"])
      video.attributes = row.to_hash.slice(*updatable_attributes)
      video.video_set = video_set
      video.save!
    end
  end

  def self.updatable_attributes
    ["netflix_id", "season", "episode", "runtime"]
  end
end
