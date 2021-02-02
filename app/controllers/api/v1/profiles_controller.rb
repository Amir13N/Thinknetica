# frozen_string_literal: true

module Api
  module V1
    class ProfilesController < Api::V1::BaseController
      def me
        render json: current_resource_owner
      end

      def index
        @users = User.where.not(id: current_resource_owner.id)
        render json: @users
      end
    end
  end
end
