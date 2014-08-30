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
    
    # @post = current_user.posts.new(post_params)
    
    if @post.save
      #write records to join table
      # post_params.sub_ids.each do |sub_id|
#         PostSub.create!(@post.id, sub_id)
#       end
      flash[:notice] = ["post successful"]
      redirect_to post_url(@post)
      # redirect_to sub_url(@post.sub)
    else
      flash[:errors] = @post.errors.full_messages
      render :new
    end
    
  end

  def edit
    @post = Post.find(params[:id])
    # @post = current_user.posts.find(params[:id])
    render :edit
  end

  def update
    @post = Post.find(params[:id])
    
    if @post.update_attributes(post_params)
      flash[:notice] = ["edit successful"]
      redirect_to post_url(@post)
    else
      flash[:errors] = @post.errors.full_messages
      render :new
    end
  end
  
  private
  def post_params
    params.require(:post).permit(:title, :url, :content, :author_id, :sub_ids => [])
  end
  
  def is_author?
    @post = Post.find(params[:id])
    unless @post.author == current_user
      flash[:errors] = ["You are not the author of this post!"]
      redirect_to post_url(@post)
    end
  end
end
