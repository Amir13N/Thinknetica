# frozen_string_literal: true

module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: %i[vote_for vote_against revote]
  end

  def vote_for
    return if current_user&.author_of?(@votable)

    @votable.vote_for(current_user)

    respond_with_rating
  end

  def vote_against
    return if current_user&.author_of?(@votable)

    @votable.vote_against(current_user)

    respond_with_rating
  end

  def revote
    return if current_user&.author_of?(@votable)

    @votable.revote(current_user)

    respond_with_rating
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
