class SearchesController < ApplicationController
  def all
    @searched_resources = ThinkingSphinx.search(ThinkingSphinx::Query.escape(params[:search]))
  end

  def questions
    @searched_questions = Question.search(params[:search])
  end

  def answers
    @question = Question.find(params[:question_id])
    @searched_answers = @question.answers.search(params[:search])
  end

  def comments
    @commentable_name = params[:commentable]
    @commentable = @commentable_name.classify.constantize.find(params[:commentable_id])
    @searched_comments = @commentable.comments.search(params[:search])
  end

  def users
    @searched_users = User.search(ThinkingSphinx::Query.escape(params[:search]))
  end
end
