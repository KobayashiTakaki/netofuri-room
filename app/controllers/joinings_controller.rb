class JoiningsController < ApplicationController
  def create
    room = Room.find(params[:room_id])
    current_user.join(room) if current_user
  end

  def destroy
    current_user.leave if current_user
  end
end
