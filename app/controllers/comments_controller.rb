class CommentsController < ApplicationController
  before_action :logged_in_user, except: [:index]
  def index
    time_from = params[:time_from] || 0
    time_to = params[:time_to]
    comments = Comment
      .by_scene(params[:scene_id])
      .order_by_time
      .time_from(time_from)
      .time_to(time_to)

    response_json = comments.map do |comment|
      comment.to_hash
    end
    respond_to do |format|
      format.html { redirect_to root_url }
      format.json { render json: response_json }
    end
  end

  def create
    user = User.find(session[:user_id])

    comment = Comment.new(strong_params)
    comment.user = user
    comment.save!
  end

  private
  def strong_params
    params.require(:comment).permit(
      :scene_id, :time, :content
    )
  end
end
