class SubscriptionsController < ApplicationController
  before_action :set_subscription, only: %i[destroy]
  before_action :set_question, only: %i[create]

  def create
    authorize! :subscribe, Question
    current_user.subscribes.push(@question) unless @question.subscribed?(current_user)
  end

  def destroy
    authorize! :subscribe, Question
    @subscription&.destroy
  end

  private

  def set_subscription
    @subscription = Subscription.find_by(question_id: params[:question_id].to_i, user_id: params[:user_id].to_i)
  end

  def set_question
    @question = Question.find(params[:question_id])
  end
end
