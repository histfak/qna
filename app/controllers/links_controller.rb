class LinksController < ApplicationController
  before_action :authenticate_user!, only: :destroy

  def destroy
    link = Link.find(params[:id])
    if current_user.author_of?(link.linkable)
      link.destroy
      @resource = link.linkable
    end
  end
end
