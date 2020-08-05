# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :authenticate_user!

  before_action :set_commentable, only: :create

  after_action :publish_comment, only: :create

  def create
    @comment = @commentable.comments.new(comment_params.merge(user: current_user))

    if @comment.save
      flash.now[:notice] = 'Your comment was successfully added.'
    else
      flash.now[:alert] = 'Your comment was not added.'
    end
  end

  private

  def publish_comment
    return if @comment.errors.any?

    ActionCable.server.broadcast(
      'comments',
      ApplicationController.render(
        partial: 'comments/comment',
        locals: { comment: @comment }
      )
    )
  end

  def set_commentable
    @commentable = commentable_name.classify.constantize.find(params[:commentable_id])
  end

  def commentable_name
    params[:commentable]
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
