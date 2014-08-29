class SubsController < ApplicationController
  before_action :logged_in?
  before_action :is_moderator?, only: [:update]

  def index
    @subs = Sub.all
    render :index
  end
  
  def new
    @sub = Sub.new
    render :new
  end
  
  def create
    @sub = Sub.new(sub_params)
    @sub.moderator_id = current_user.id
    
    if @sub.save
      redirect_to sub_url(@sub)
    else
      flash[:errors] = @sub.errors.full_messages
      render :new
    end
  end
  
  def edit
    @sub = Sub.find(params[:id])
    render :edit
  end
  
  def update
    @sub = Sub.find(params[:id])
    if @sub.update_attributes(sub_params)
      flash[:errors] = ["Successfully updated!"]
      redirect_to sub_url(@sub)
    else
      flash.now[:errors] = @sub.errors.full_messages
      render :edit
    end  
  end
  
  def show
    @sub = Sub.find(params[:id])
    render :show
  end
  
  private 
  def sub_params
    params.require(:sub).permit(:title, :description, :moderator_id)
  end
  
  def is_moderator?
    @sub = Sub.find(params[:id])
    unless @sub.moderator == current_user
      flash[:errors] = ["You aren't the moderator."]
      redirect_to sub_url(@sub)
    end
  end
end
