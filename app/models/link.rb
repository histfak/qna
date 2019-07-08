class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates :name, :url, presence: true
  validates_format_of :url, with: URI::ABS_URI

  def gist?
    return true if (url =~ /^https:\/\/gist.github.com\/\w\/*/) == 0

    false
  end

  def gist_fetch_content
    gist = Octokit.gist(gist_get_resource_id(url))
    resource = gist.files.to_hash.to_a
    resource[0][1][:content] # grabbing the needed value inside the Sawyer::Resource object
  end

  private

  def gist_get_resource_id(url)
    url.split('/').last
  end
end
