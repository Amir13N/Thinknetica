# frozen_string_literal: true

module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: %i[vote_for vote_against revote]
  end

  def vote_for
    if !current_user&.author_of?(@votable) && user_signed_in?
      @votable.vote_for(current_user)

      respond_with_rating
    end
  end

  def vote_against
    if !current_user&.author_of?(@votable) && user_signed_in?
      @votable.vote_against(current_user)

      respond_with_rating
    end
  end

  def revote
    if !current_user&.author_of?(@votable) && user_signed_in?
      @votable.revote(current_user)

      respond_with_rating
    end
  end

  private

  def respond_with_rating
    respond_to do |format|
      format.json { render json: @votable.rating }
    end
  end

  def model_klass
    controller_name.classify.constantize
  end

  def set_votable
    @votable = model_klass.find(params[:id])
  end
end
