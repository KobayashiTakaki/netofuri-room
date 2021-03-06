class Room < ApplicationRecord
  has_one :scene, dependent: :destroy
  has_many :viewings, dependent: :destroy
  delegate :video, to: :scene

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
        id: video.id,
        type: video.video_type,
        title: video.title,
        season: video.season,
        episode: video.episode,
        netflix_id: video.netflix_id
      },
      scene: {
        id: scene.id,
        title: scene.title,
        start_time: scene.start_time,
        end_time: scene.end_time
      },
      users: active_viewing.users.map { |u| u.id }
    }
  end
end
