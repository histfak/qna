class AttachmentsController < ApplicationController
  before_action :authenticate_user!, only: :destroy

  authorize_resource class: ActiveStorage::Attachment

  def destroy
    file = ActiveStorage::Attachment.find(params[:id])
    file.purge
    @resource = file.record
  end
end
