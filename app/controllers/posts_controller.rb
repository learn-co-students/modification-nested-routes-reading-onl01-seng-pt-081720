class PostsController < ApplicationController

  def index
    if params[:author_id]
      @posts = Author.find(params[:author_id]).posts
    else
      @posts = Post.all
    end
  end

  def show
    if params[:author_id]
      @post = Author.find(params[:author_id]).posts.find(params[:id])
    else
      @post = Post.find(params[:id])
    end
  end

  def new
    # byebug
    if params[:author_id] && !Author.exists?(params[:author_id])
      redirect_to authors_path, alert: "Author not found."

      # Here we check for params[:author_id] and then for Author.exists? to see if the author is real.
    else
      @post = Post.new(author_id: params[:author_id])
    end

    #author_id done in a params thru a nested route
    #track it & assign the post to that author
    #added author_id in posts/_form particles as a hidden field for
    #the new action
  end
  # http://localhost:3000/posts/new 
  # aka
  # http://localhost:3000/authors/id/posts/new
  # <input type="hidden" value="id" name="post[author_id]" id="post_author_id">
  # <input type="text" name="post[title]" id="post_title">
  def create
    #updated post_params w/ author_id aka allows for 
    #mass-assignment in the create action
    @post = Post.new(post_params)
    @post.save
    redirect_to post_path(@post)
  end

  def update
    @post = Post.find(params[:id])
    @post.update(post_params)
    redirect_to post_path(@post)
  end

  def edit
    if params[:author_id]
      author = Author.find_by(id: params[:author_id])
      if author.nil?
        redirect_to authors_path, alert: "Author not found."
      else
        @post = author.posts.find_by(id: params[:id])
        redirect_to author_posts_path(author), alert: "Post not found." if @post.nil?
      end
    else
      @post = Post.find(params[:id])
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :description, :author_id)
  end
end
