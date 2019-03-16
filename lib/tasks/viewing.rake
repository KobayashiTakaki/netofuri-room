namespace :viewing do
  desc "viewing task"
  # 再生予定のviewingを作成する
  task create: :environment do
    scenes = Scene.all
    scenes.each do |scene|
      start_time = Time.zone.now
      to_time = Time.zone.now + 2.hour
      latest_viewing = Viewing.where(scene: scene).latest

      if latest_viewing.present?
        # 最新のviewingのend_timeから始める
        start_time = latest_viewing.end_time
        # もうto_timeより後まであったらやめる
        next if start_time > to_time
      end

      created_viewing = nil
      while !created_viewing || created_viewing.end_time < to_time do
        viewing = Viewing.new
        viewing.scene = scene
        viewing.room = scene.room
        viewing.start_time = start_time
        viewing.end_time = start_time + scene.runtime.second
        viewing.save!
        start_time = viewing.end_time
        created_viewing = viewing
      end
    end
  end

  task destroy_old: :environment do
    keep_from = Time.zone.now - 2.hour
    viewings = Viewing.where("end_time < ?", keep_from)
    viewings.each do |viewing|
      viewing.destroy!
    end
  end
end
