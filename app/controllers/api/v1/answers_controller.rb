# frozen_string_literal: true

module Api
  module V1
    class AnswersController < Api::V1::BaseController
      before_action :set_answer, only: %i[show update destroy]
      before_action :set_question, only: %i[create]

      def show
        render json: @answer
      end

      def update
        authorize! :update, @answer
        @answer.update(answer_params)
      end

      def destroy
        authorize! :delete, @answer
        @answer.destroy
      end

      def create
        authorize! :new, Answer
        current_resource_owner.answers.create(answer_params.merge(question: @question))
      end

      private

      def set_question
        @question = Question.find(params[:question_id])
      end

      def set_answer
        @answer = Answer.find(params[:id])
      end

      def answer_params
        params.require(:answer).permit(:body, :correct, links_attributes: %i[name url])
      end
    end
  end
end
