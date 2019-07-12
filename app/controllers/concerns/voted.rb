module Voted
  extend ActiveSupport::Concern

  included do
    before_action :load_votable, only: %i[like dislike reset]
    before_action :load_vote, only: %i[like dislike reset]
  end

  def like
    if @vote
      @vote.like
    else
      @votable.new_like(current_user)
    end

    scores
  end

  def dislike
    if @vote
      @vote.dislike
    else
      @votable.new_dislike(current_user)
    end

    scores
  end

  def reset
    @vote.reset if @vote

    scores
  end

  private

  def scores
    render json: { scores: @votable.scores, id: @votable.id, type: action_name }
  end

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
