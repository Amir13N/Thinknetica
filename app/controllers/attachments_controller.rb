# frozen_string_literal: true

class AttachmentsController < ApplicationController
  def destroy
    @attachment = ActiveStorage::Attachment.find(params[:id])
    @record = @attachment.record
    @record_class = @record.class.to_s.downcase
    if current_user&.author_of?(@record)
      @attachment.purge
    else
      flash.now[:alert] = "This #{@record_class} does not belong to you or you are not signed in."
    end
  end
end
