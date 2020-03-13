class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :created_at, :updated_at
  belongs_to :author
  belongs_to :question
  has_many :comments
  has_many :links
  has_many :files, serializer: AttachmentSerializer
end
