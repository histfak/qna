class Question < ApplicationRecord
  include Linkable
  include Fileable
  include Authorable
  include Votable
  include Commentable

  has_many :answers, dependent: :destroy
  has_one :reward, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :subscribers, through: :subscriptions, source: :user

  accepts_nested_attributes_for :reward, reject_if: :all_blank, allow_destroy: true

  validates :title, :body, presence: true

  scope :past_day, -> { where(created_at: (Time.current.yesterday.beginning_of_day..Time.current.yesterday.end_of_day)) }

  def subscription(user)
    subscriptions.where(user: user).first
  end

  def subscribe!(user)
    subscriptions.create(user: user) unless subscription(user)
  end

  def unsubscribe!(user)
    subscription(user)&.destroy!
  end
end
