class Admin::VideosController < ApplicationController
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
    Video.import(params[:file])
    redirect_to admin_videos_path, notice: "videos import done"
  end
end
