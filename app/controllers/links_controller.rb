# frozen_string_literal: true

class LinksController < ApplicationController
  def destroy
    @link = Link.find(params[:id])
    authorize! :delete_link, @link.linkable
    @linkable_class = @link.linkable.class.to_s.downcase
    @link.destroy
  end
end
