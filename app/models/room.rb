class Room < ApplicationRecord
  has_one :video_set, dependent: :destroy
  has_many :viewings, dependent: :destroy

  def active_viewing
    viewings.active.first
  end

  scope :active, -> { joins(:viewings).merge(Viewing.active) }
  scope :sort_by_joinings, -> { order("viewings.joinings_count desc") }
  scope :sort_by_start_time, -> { order("viewings.start_time desc") }

  def to_hash
    {
      id: self.id,
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
