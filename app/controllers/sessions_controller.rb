class SessionsController < ApplicationController
  before_action :redirect_loggedin_user, only: :new

  def new
    render 'sessions/new'
  end

  def create
    user = User.find_by(name: params[:session][:name])
    if user && user.authenticate(params[:session][:password])
      log_in(user)
      redirect_back_or root_path
    else
      flash.now[:error] = 'ログインに失敗しました。'
      render 'sessions/new'
    end
  end

  def destroy
    log_out
  end

  private
  def redirect_loggedin_user
    redirect_to root_path if current_user
  end
end
