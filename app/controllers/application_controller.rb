# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :set_gon_user, unless: :devise_controller?

  private

  def set_gon_user
    gon.user_id == current_user if current_user
  end
end
