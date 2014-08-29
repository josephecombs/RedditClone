class SessionsController < ApplicationController
  def new
    @user = User.new
    render :new
  end

  def create  
    # @user = User.new(session_params)
    user = User.find_by_credentials(
        session_params[:username],
        session_params[:password]
        )
    
    if user
      login_user! user
      redirect_to root_url
    else
      # fail
      flash.now[:errors] = ["Can't find user"]
      @user = User.new(username: session_params[:username])
      render :new
    end
  end

  def destroy
    session[:token] = nil
    current_user.reset_session_token!
  end
  
  private
  def session_params
    params.require(:user).permit(:username, :password)
  end
end
