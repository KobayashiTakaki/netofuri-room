namespace :viewing do
  desc "viewing task"
  task create: :environment do
    video_sets = VideoSet.all
    video_sets.each do |video_set|
      video_set.create_upcoming_viewings
    end
  end

  task destroy_old: :environment do
    keep_from = Time.zone.now - 24.hour
    viewings = Viewing.where("end_time < ?", keep_from)
    viewings.each do |viewing|
      viewing.destroy!
    end
  end
end
