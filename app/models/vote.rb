class Vote < ApplicationRecord
  include Authorable

  belongs_to :user
  belongs_to :votable, polymorphic: true, touch: true

  validates :user_id, uniqueness: { scope: [:votable_id, :votable_type] }
  validates :score, presence: true

  def like
    update!(score: 1)
  end

  def dislike
    update!(score: -1)
  end

  def reset
    delete
  end
end
