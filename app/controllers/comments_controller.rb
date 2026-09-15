# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :set_commentable, only: :create
  before_action :set_comment, only: :destroy
  before_action :check_permission, only: :destroy

  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.user_id = current_user.id

    if @comment.save
      redirect_to @commentable, notice: t('controllers.common.notice_create', name: Comment.model_name.human)
    else
      redirect_to @commentable, alert: t('controllers.common.alert_required', name: Comment.model_name.human)
    end
  end

  def destroy
    @comment.destroy

    redirect_to @comment.commentable, notice: t('controllers.common.notice_destroy', name: Comment.model_name.human)
  end

  private

  def set_commentable
    if params[:report_id].present?
      @commentable = Report.find(params.expect(:report_id))
    elsif params[:book_id].present?
      @commentable = Book.find(params.expect(:book_id))
    end
  end

  def set_comment
    @comment = Comment.find(params.expect(:id))
  end

  def comment_params
    params.expect(comment: :content)
  end

  def check_permission
    return if @comment.user_id == current_user.id

    redirect_to @comment.commentable, alert: t('controllers.common.alert_no_permission', name: Comment.model_name.human)
  end
end
