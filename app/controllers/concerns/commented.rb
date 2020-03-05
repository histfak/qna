module Commented
  extend ActiveSupport::Concern

  included do
    before_action :load_commentable, only: %i[create_comment]
    after_action :publish_comment, only: %i[create_comment]
  end

  def create_comment
    @comment = @commentable.comments.new(comment_params)
    @comment.author = current_user

    if @comment.save
      render json: @comment
    else
      render json: @comment.errors.full_messages, status: :unprocessable_entity
    end
  end

  private

  def publish_comment
    return if @comment.errors.any?

    ActionCable.server.broadcast('comments', comment: @comment )
  end

  def load_commentable
    @commentable = model_klass.find(params[:id])
  end

  def model_klass
    controller_name.classify.constantize
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
