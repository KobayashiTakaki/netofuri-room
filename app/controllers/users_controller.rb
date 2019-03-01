class UsersController < ApplicationController
  before_action :logged_in_user, except: [:new, :create, :show]

  def new
    @user = User.new
  end

  def create
    @user = User.new(strong_params)
    if @user.save
      redirect_to root_url
    else
      render 'users/new'
    end
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update_attributes(strong_params)
      redirect_to root_url
    else
      render 'users/edit'
    end
  end

  private
  def strong_params
    params.require(:user).permit(
      [:name, :display_name, :password, :password_confirmation]
    )
  end
end
