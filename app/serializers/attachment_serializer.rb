class AttachmentSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :filename, :created_at, :url

  def url
    Rails.application.routes.url_helpers.rails_blob_url(object, only_path: true)
  end
end
