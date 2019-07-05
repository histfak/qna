class AttachmentsController < ApplicationController
  before_action :authenticate_user!, only: :destroy

  def destroy
    file = ActiveStorage::Attachment.find(params[:id])
    if current_user.author?(file.record)
      file.purge
      case file.record_type
      when 'Question' then @question = file.record
      when 'Answer' then @answer = file.record
      end
    end
  end
end
