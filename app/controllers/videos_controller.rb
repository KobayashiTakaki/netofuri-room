class VideosController < ApplicationController
  def show
    video = Video.find_or_scrape(params[:id])
    render json: video
  end
end
