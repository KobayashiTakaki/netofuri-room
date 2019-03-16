class Admin::ScenesController < Admin::AdminController
  def new
    @video = Video.find(params[:video_id])
    @scene = Scene.new
  end

  def create
    @video = Video.find(params[:video_id])
    @scene = Scene.new(strong_params)
    @scene.video = @video
    @scene.room = Room.new
    if @scene.save
      redirect_to admin_video_path(@video)
    else
      render 'admin/scenes/new'
    end
  end

  def destroy
    scene = Scene.find(params[:id])
    video = scene.video
    scene.destroy!
    redirect_to admin_video_path(video)
  end

  private
  def strong_params
    params.require(:scene).permit(
      [:title, :start_time, :end_time]
    )
  end
end
