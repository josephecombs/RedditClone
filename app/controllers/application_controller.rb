class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception
  helper_method :current_user, :login_user!, :logged_in?
  def current_user
    User.find_by_session_token(session[:token])
  end
  
  def logged_in?
    unless current_user
      flash[:errors] = ["you are not logged in"]
      redirect_to new_session_url
    end
  end
  
  def login_user! user
    user.reset_session_token!
    session[:token] = user.session_token
  end
  
  ##ma y need
#   def logout_user!
#   end


end
