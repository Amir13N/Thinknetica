class AnswersController < ApplicationController
  expose :question, id: -> { params[:question_id] }
  expose :answers, model: -> { Answer.all }
  expose :answer

  def create
    answer = question.answers.new(answer_params)
    current_user.answers.push(answer)

    if answer.save
      redirect_to question, notice: 'Your answer was successfully created.'
    else
      redirect_to question_path(question, answer: answer_params)
    end

  end

  def update
    if answer.update(answer_params)
      redirect_to question_answer_path(question)
    else
      render :edit
    end
  end

  def destroy
    answer.destroy
    redirect_to question_path(question), notice: 'Your answer was successfully deleted.'
  end

  private

  def answer_params
    params.require(:answer).permit(:body, :correct)
  end
end
