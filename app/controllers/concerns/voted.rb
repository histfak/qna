module Voted
  extend ActiveSupport::Concern

  included do
    before_action :load_votable, only: %i[like dislike reset]
    before_action :load_vote, only: %i[like dislike reset]
  end

  def like
    if @votable.voted?(current_user)
      render json: { status: :unprocessable_entity }
    elsif !current_user.author_of?(@votable)
      if @vote
        @vote.like
      else
        @votable.new_like(current_user)
      end

      render json: { scores: @votable.scores, id: @votable.id, type: action_name }
    else
      render json: { status: :unprocessable_entity }
    end
  end

  def dislike
    if @votable.voted?(current_user)
      render json: { status: :unprocessable_entity }
    elsif !current_user.author_of?(@votable)
      if @vote
        @vote.dislike
      else
        @votable.new_dislike(current_user)
      end

      render json: { scores: @votable.scores, id: @votable.id, type: action_name }
    else
      render json: { status: :unprocessable_entity }
    end
  end

  def reset
    if @vote && current_user.author_of?(@vote)
      @vote.reset

      render json: { scores: @votable.scores, id: @votable.id, type: action_name }
    else
      render json: { status: :unprocessable_entity }
    end
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def load_votable
    @votable = model_klass.find(params[:id])
  end

  def load_vote
    @vote = @votable.votes.find_by(user: current_user)
  end
end
