# frozen_string_literal: true

class AttachmentsController < ApplicationController
  def destroy
    @attachment = ActiveStorage::Attachment.find(params[:id])
    @record = @attachment.record
    authorize! :delete_attachment, @record
    @record_class = @record.class.to_s.downcase
    @attachment.purge
  end
end
