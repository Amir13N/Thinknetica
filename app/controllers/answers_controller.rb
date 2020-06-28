# frozen_string_literal: true

class AnswersController < ApplicationController
  expose :question, id: -> { params[:question_id] }
  expose :answers, -> { Answer.all }
  expose :answer

  before_action :authenticate_user!, except: 'show'

  def create
    @answer = question.answers.new(answer_params)
    current_user.answers.push(@answer)

    if @answer.save
      redirect_to question, notice: 'Your answer was successfully created.'
    else
      render 'questions/show', location: question
    end
  end

  def update
    @answer = answer

    if @answer.update(answer_params)
      redirect_to question, notice: 'Your answer was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    answer.destroy
    redirect_to question, notice: 'Your answer was successfully deleted.'
  end

  private

  def answer_params
    params.require(:answer).permit(:body, :correct)
  end
end
