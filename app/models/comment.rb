class Comment < ApplicationRecord
  include Authorable

  belongs_to :user
  belongs_to :commentable, polymorphic: true

  validates :body, presence: true
end
