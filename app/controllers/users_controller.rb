class UsersController < ApplicationController
  def new
    @user = User.new
    render :new
  end

  def create
    @user = User.new(user_params)
    
    if @user.save
      login_user! @user
      redirect_to root_url
    else
      flash.now[:errors] = @user.errors.full_messages
      render :new
    end
  end

  def edit
  end

  def index
  end

  def show
  end

  def update
  end

  def destroy
  end
  
  private
  def user_params
    params.require(:user).permit(:username, :password)
  end
end
