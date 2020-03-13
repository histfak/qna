class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :created_at, :updated_at
  belongs_to :author
  has_many :answers
  has_many :comments
  has_many :links
  has_many :files, serializer: AttachmentSerializer
end
