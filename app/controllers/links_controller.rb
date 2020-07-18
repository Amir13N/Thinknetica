# frozen_string_literal: true

class LinksController < ApplicationController
  def destroy
    @link = Link.find(params[:id])
    @linkable_class = @link.linkable.class.to_s.downcase
    if current_user&.author_of?(@link.linkable)
      @link.destroy
    else
      flash.now[:alert] = "This #{@linkable_class} does not belong to you or you are not signed in."
    end
  end
end
