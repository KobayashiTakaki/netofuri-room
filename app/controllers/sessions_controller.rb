class SessionsController < ApplicationController
  def new
    back_path = Rails.application.routes.recognize_path(request.referer)
    store_location(back_path)
    render 'sessions/new'
  end

  def create
    user = User.find_by(name: params[:session][:name])
    if user && user.authenticate(params[:session][:password])
      log_in(user)
      redirect_back_or root_path
    else
      render 'sessions/new'
    end
  end

  def destroy
    log_out
  end

end
