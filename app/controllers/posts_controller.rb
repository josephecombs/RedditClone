class PostsController < ApplicationController
  before_action :is_author?, only: [:edit, :update]
  before_action :logged_in?, only: [:create, :new]
  
  def show
    @post = Post.find(params[:id])
    render :show
  end

  def new
    @post = Post.new
    render :new
  end

  def create
    @post = Post.new(post_params)
    
    @post.author_id = current_user.id
    @post.sub_id = params[:sub_id] 
    
    if @post.save
      flash[:errors] = ["post successful"]
      redirect_to sub_url(@post.sub)
    else
      flash[:errors] = @post.errors.full_messages
      render :new
    end
    
  end

  def edit
    @post = Post.find(params[:id])
    render :edit
  end

  def update
    @post = Post.find(params[:id])
    
    if @post.update_attributes(post_params)
      flash[:errors] = ["edit successful"]
      redirect_to sub_url(@post.sub)
    else
      flash[:errors] = @post.errors.full_messages
      render :new
    end
  end
  
  private
  def post_params
    params.require(:post).permit(:title, :url, :content, :sub_id, :author_id)
  end
  
  def is_author?
    unless @post.author == current_user
      flash[:errors] = ["You are not the author of this post!"]
      redirect_to post_url(@post)
    end
  end
end
