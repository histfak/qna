module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, dependent: :destroy, as: :votable
  end

  def scores
    votes.sum(:score)
  end

  def voted?(user)
    return true if votes.find_by(user_id: user.id)

    false
  end

  def new_like(user)
    votes.create(user: user, score: 1)
  end

  def new_dislike(user)
    votes.create(user: user, score: -1)
  end
end
