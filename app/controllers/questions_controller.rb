# frozen_string_literal: true

class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  before_action :set_question, only: %i[show edit update destroy]

  def show
    @answer = Answer.new
    @answer.links.new
  end

  def index
    @questions = Question.all
  end

  def new
    @question = current_user.questions.new
    @question.links.new
  end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      redirect_to questions_path, notice: 'Your question was successfully created.'
    else
      render :new
    end
  end

  def update
    @questions = Question.all
    if @question.update(question_params)
      flash.now[:notice] = 'Your answer was successfully updated.'
    else
      flash.now[:alert] = 'Your answer was not updated.'
    end
  end

  def destroy
    if current_user.author_of?(@question)
      @question.destroy
      redirect_to questions_path, notice: 'Your question was successfully deleted.'
    else
      redirect_to questions_path, alert: 'You can only delete your own questions.'
    end
  end

  private

  def set_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:body, :title, files: [], links_attributes: %i[id name url _destroy])
  end
end
