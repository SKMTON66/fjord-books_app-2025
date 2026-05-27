# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user, only: %i[show]

  # GET /users
  def index
    @users = User.order(created_at: :desc).page(params[:page]).per(5)
  end

  # GET /users/:id
  def show; end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params.expect(:id))
  end
end
