# frozen_string_literal: true

module Api
  module V1
    class QuestionsController < Api::V1::BaseController
      before_action :set_question, only: %i[show update destroy]

      def index
        @questions = Question.all
        render json: @questions
      end

      def show
        render json: @question
      end

      def update
        authorize! :update, @question
        @question.update(question_params)
      end

      def destroy
        authorize! :delete, @question
        @question.destroy
      end

      def create
        authorize! :new, Question
        current_resource_owner.questions.create(question_params)
      end

      private

      def set_question
        @question = Question.find(params[:id])
      end

      def question_params
        params.require(:question).permit(:body, :title, links_attributes: %i[id name url _destroy],
                                                        reward_attributes: %i[title picture])
      end
    end
  end
end
