# frozen_string_literal: true

class QuestionsController < ApplicationController
  expose :questions, -> { Question.all }
  expose :question
  expose :answers, -> { question.answers }
  expose :answer, model: -> { question.answers }, id: -> { params[:answer_id] }

  before_action :authenticate_user!, except: %i[index show]

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      redirect_to questions_path, notice: 'Your question was successfully created.'
    else
      render :new
    end
  end

  def update
    if question.update(question_params)
      redirect_to question_path(question), notice: 'Your question was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    question.destroy
    redirect_to questions_path, notice: 'Your question was successfully deleted.'
  end

  private

  def question_params
    params.require(:question).permit(:body, :title)
  end
end
