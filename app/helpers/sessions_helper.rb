module SessionsHelper
  def log_in(user)
    session[:user_id] = user.id
  end

  def log_out
    session[:user_id] = nil
    current_user.leave if current_user
    current_user = nil
    redirect_to root_url
  end

  def current_user
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    end
  end

  def logged_in?
    !current_user.nil?
  end

  def logged_in_user
    unless logged_in?
      redirect_to root_url
    end
  end
end
