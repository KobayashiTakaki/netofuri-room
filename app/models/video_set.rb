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

  def latest_viewing
    Viewing.for_video_set(self).latest
  end

  # 再生予定のviewingを作成する
  def create_upcoming_viewings
    to_time = Time.zone.now + 24.hour
    latest_viewing ||= Viewing.new(room: Room.create!)
    room = latest_viewing.room
    # 最新のviewingのend_timeから始める
    start_time = latest_viewing.end_time || Time.zone.now

    # もうto_timeより後まであったらやめる
    return if start_time > to_time

    video_ids = videos.order(:season, :episode).ids

    # last_viewingのvideoの次のvideoから始める
    if latest_viewing.video && video_type == "show"
      ids_first = video_ids.drop(video_ids.index(latest_viewing.video.id)+1)
      ids_last = video_ids.take(video_ids.index(latest_viewing.video.id)+1)
      video_ids = ids_first + ids_last
    end

    index = 0
    created_viewing = nil
    while !created_viewing || created_viewing.end_time < to_time do
      viewing = Viewing.new
      viewing.room = room
      video = Video.find_by_id(video_ids[index])
      viewing.video = video
      viewing.start_time = start_time
      viewing.end_time = start_time + video.runtime.second
      viewing.save!
      start_time = viewing.end_time
      created_viewing = viewing
      index += 1
      # video ids配列をループさせる
      if index == (video_ids.size)
        index = 0
      end
    end
  end
end
