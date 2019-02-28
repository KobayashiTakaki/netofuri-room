class RoomsController < ApplicationController
  def index
    rooms = Room.active
    response_json = rooms.map do |room|
      room.to_hash
    end
    respond_to do |format|
      format.html { redirect_to root_url }
      format.json { render json: response_json }
    end

  end

  def show
    room = Room.find(params[:id])
    respond_to do |format|
      format.html
      format.json { render json: room.to_hash }
    end

  end
end
