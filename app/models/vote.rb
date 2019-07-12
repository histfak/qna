class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :votable, polymorphic: true

  validates :user_id, uniqueness: { scope: [:votable_id, :votable_type] }
  validates :score, presence: true

  def like
    if score
      update!(score: 1)
    else

    end
  end

  def dislike
    update!(score: -1)
  end

  def reset
    delete
  end
end
