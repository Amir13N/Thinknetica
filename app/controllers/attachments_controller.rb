class AttachmentsController < ApplicationController
  def destroy
    @attachment = ActiveStorage::Attachment.find(params[:id])
    @record = @attachment.record
    if current_user&.author_of?(@record)
      @record_class = @record.class.to_s.downcase
      @attachment.purge
    else
      flash.now[:alert] = "This #{@record_class} does not belong to you or you are not signed in."
    end
  end
end
