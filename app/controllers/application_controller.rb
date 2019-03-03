class ApplicationController < ActionController::Base
  include SessionsHelper

  private
  # ログイン済みユーザーかどうか確認
  def logged_in_user
    unless logged_in?
      log_out current_user
      redirect_to root_url
    end
  end

  def allow_admin
    unless current_user.admin
      redirect_to root_url
    end
  end
end
