class CommentsController < ApplicationController
  def index
    time_from = params[:time_from] || 0
    time_to = params[:time_to]
    comments = Comment
      .by_video(params[:video_id])
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
    # セッションから取る。あとで直す
    user = User.first

    comment = Comment.new
    comment.user = user
    comment.update_attributes(strong_params)
    comment.save!
  end

  private
  def strong_params
    params.require(:comment).permit(
      :video_id, :time, :content
    )
  end
end