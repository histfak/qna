class Question < ApplicationRecord
  include Linkable
  include Fileable
  include Authorable
  include Votable
  include Commentable

  has_many :answers, dependent: :destroy
  has_one :reward, dependent: :destroy

  accepts_nested_attributes_for :reward, reject_if: :all_blank, allow_destroy: true

  validates :title, :body, presence: true
end
