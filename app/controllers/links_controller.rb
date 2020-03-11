class LinksController < ApplicationController
  before_action :authenticate_user!, only: :destroy

  authorize_resource

  def destroy
    link = Link.find(params[:id])
    link.destroy
    @resource = link.linkable
  end
end
