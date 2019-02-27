class RoomsController < ApplicationController
  def index
    rooms = Room.all
    response_json = rooms.map do |room|
      room.to_hash
    end
    render json: response_json
  end

  def show
  end
end
