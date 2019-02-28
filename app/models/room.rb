class Room < ApplicationRecord
  has_one :video_set
  has_many :viewings

  def active_viewing
    viewings.active
  end

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
