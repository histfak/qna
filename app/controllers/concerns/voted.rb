module Voted
  extend ActiveSupport::Concern

  included do
    before_action :load_votable, only: %i[like dislike reset]
    before_action :load_vote, only: %i[like dislike reset]
  end

  def like
    vote(__method__)
  end

  def dislike
    vote(__method__)
  end

  def reset
    if !@votable.voted?(current_user)
      error
    else
      if @vote && current_user.author_of?(@vote)
        @vote.reset

        scores
      else
        error
      end
    end
  end

  private

  def vote(method)
    if @votable.voted?(current_user)
      error
    elsif !current_user.author_of?(@votable)
      if @vote
        eval "@vote.#{method}"
      else
        eval "@votable.new_#{method}(current_user)"
      end

      scores
    else
      error
    end
  end

  def scores
    render json: { scores: @votable.scores, id: @votable.id, type: action_name }
  end

  def error
    render json: { status: :unprocessable_entity }
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
