class Admin::VideosController < Admin::AdminController
  def import
    Video.import(params[:file])
    redirect_to admin_video_sets_path, notice: "videos import done"
  end
end
