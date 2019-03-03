module SessionsHelper
  def log_in(user)
    session[:user_id] = user.id
  end

  def log_out
    current_user.leave
    session[:user_id] = nil
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

  def redirect_back_or(default)
    redirect_to(session[:back_path] || default)
    session.delete(:back_path)
  end

  def store_location(path)
    session[:back_path] = path
  end
end
