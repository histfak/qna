class Vote < ApplicationRecord
  belongs_to :user, dependent: :destroy
  belongs_to :votable, polymorphic: true

  validates :user_id, uniqueness: { scope: [:votable_id, :votable_type] }
  validates :score, presence: true

  def like
    update!(score: 1)
  end

  def dislike
    update!(score: -1)
  end

  def reset
    update!(score: 0)
  end
end
