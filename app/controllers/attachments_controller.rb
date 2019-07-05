class AttachmentsController < ApplicationController
  before_action :authenticate_user!, only: :destroy

  def destroy
    file = ActiveStorage::Attachment.find(params[:id])
    if current_user.author?(file.record)
      file.purge
      @resource = file.record
    end
  end
end
