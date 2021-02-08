# frozen_string_literal: true

class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  include Voted

  before_action :set_question, only: %i[show edit update destroy subscribe unsubscribe]

  after_action :publish_question, only: :create

  def show
    @answer = Answer.new
    @answer.links.new
    @comment = Comment.new
  end

  def index
    @questions = Question.all
  end

  def new
    authorize! :create, Question
    @question = current_user.questions.new
    @question.links.new
    Reward.new(question: @question)
  end

  def edit
    authorize! :update, @question
  end

  def create
    authorize! :create, Question
    @question = current_user.questions.new(question_params)

    if @question.save
      redirect_to questions_path, notice: 'Your question was successfully created.'
    else
      render :new
    end
  end

  def update
    authorize! :update, @question
    @questions = Question.all
    if @question.update(question_params)
      flash.now[:notice] = 'Your question was successfully updated.'
    else
      flash.now[:alert] = 'Your question was not updated.'
    end
  end

  def destroy
    authorize! :delete, @question
    @question.destroy
    redirect_to questions_path, notice: 'Your question was successfully deleted.'
  end

  private

  def publish_question
    return if @question.errors.any?

    ActionCable.server.broadcast(
      'questions',
      @question.body
    )
  end

  def set_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:body, :title, files: [], links_attributes: %i[id name url _destroy],
                                                    reward_attributes: %i[title picture])
  end
end
