class Room < ApplicationRecord
  has_one :scene, dependent: :destroy
  has_many :viewings, dependent: :destroy

  scope :active_at, ->(time) { joins(:viewings).merge(Viewing.active_at(time)) }
  scope :sort_by_joinings, -> { order("viewings.joinings_count desc") }
  scope :sort_by_start_time, -> { order("viewings.start_time desc") }

  def to_hash
    active_viewing = viewings.active_at(Time.zone.now).first
    {
      id: id,
      viewing: {
        start_time: active_viewing.start_time,
        end_time: active_viewing.end_time
      },
      video: {
        id: active_viewing.video.id,
        type: video_set.video_type,
        title: video_set.title,
        season: active_viewing.video.season,
        episode: active_viewing.video.episode,
        runtime: active_viewing.video.runtime,
        netflix_id: active_viewing.video.netflix_id
      },
      users: active_viewing.users.map { |u| u.id }
    }
  end
end
