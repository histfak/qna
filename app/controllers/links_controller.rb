class LinksController < ApplicationController
  before_action :authenticate_user!, only: :destroy

  authorize_resource

  def destroy
    link = Link.find(params[:id])
    authorize! :destroy, link
    link.destroy
    @resource = link.linkable
  end
end
