class Admin::VideoSetsController < Admin::AdminController
  def index
    @video_sets = VideoSet.all
  end

  def show
    @video_set = VideoSet.find(params[:id])
  end

  def destroy
    video_set = VideoSet.find(params[:id])
    video_set.destroy!
    redirect_to admin_video_sets_path
  end

  def import
    VideoSet.import(params[:file])
    redirect_to admin_video_sets_path, notice: "video sets import done"
  end
end
