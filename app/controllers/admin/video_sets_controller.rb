class Admin::VideoSetsController < ApplicationController
  def index
  end

  def show
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end

  def import
    VideoSet.import(params[:file])
    redirect_to admin_video_sets_path, notice: "video sets import done"
  end
end
