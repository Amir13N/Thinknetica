# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_user!, except: 'show'

  include Voted

  before_action :set_answer, only: %i[edit update destroy choose_best show]
  before_action :set_question, only: %i[create]

  after_action :publish_answer, only: :create

  def create
    @answer = current_user.answers.new(answer_params.merge(question: @question))

    if @answer.save
      flash.now[:notice] = 'Your answer was successfully created.'
    else
      flash.now[:alert] = 'Your answer was not created.'
    end
  end

  def update
    @question = @answer.question
    if @answer.update(answer_params)
      flash.now[:notice] = 'Your answer was successfully updated.'
    else
      flash.now[:alert] = 'Your answer was not updated.'
    end
  end

  def destroy
    if current_user.author_of?(@answer)
      @answer.destroy
      flash.now[:notice] = 'Your answer was successfully deleted.'
    end
  end

  def choose_best
    if current_user&.author_of?(@answer.question)
      @answer.make_best
      flash.now[:notice] = 'Your answer was successfully chosen as the best'
      render 'answers/choose_best'
    end
  end

  def show
    @comment = Comment.new
  end

  private

  def publish_answer
    return if @answer.errors.any?

    ActionCable.server.broadcast(
      'answers',
      @answer.body
    )
  end

  def set_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, :correct, files: [], links_attributes: %i[name url])
  end
end
