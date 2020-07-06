# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_user!, except: 'show'

  before_action :set_answer, only: %i[show edit update destroy]
  before_action :set_question, only: %i[create]

  def create
    @answer = current_user.answers.new(answer_params)
    @answer.question = @question

    if @answer.save
      redirect_to @question, notice: 'Your answer was successfully created.'
    else
      render 'questions/show', location: @question
    end
  end

  def update
    if @answer.update(answer_params)
      redirect_to @answer.question, notice: 'Your answer was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    if current_user.author_of? @answer
      @answer.destroy
      redirect_to @answer.question, notice: 'Your answer was successfully deleted.'
    else
      redirect_to @answer.question, notice: 'You can only delete your own answers.'
    end
  end

  private

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def set_question
    @question = Question.find(params[:question_id])
    raise unless @question.save
  end

  def answer_params
    params.require(:answer).permit(:body, :correct)
  end
end
