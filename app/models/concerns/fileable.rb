module Fileable
  extend ActiveSupport::Concern

  included do
    has_many_attached :files
  end

  def files_params
    files.map do |file|
      { name: file.filename.to_s, url: Rails.application.routes.url_helpers.rails_blob_url(file, only_path: true) }
    end
  end
end
