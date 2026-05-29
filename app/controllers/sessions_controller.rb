# app/controllers/sessions_controller.rb
class SessionsController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]

  def new
    @users = User.all
  end

  def create
    @user = User.find(params[:user_id])
    session[:user_id] = @user.id
    redirect_to root_path, notice: "Logged in as #{@user.name}"
  end

  def destroy
    session[:user_id] = nil
    redirect_to new_session_path, notice: "Logged out"
  end
end
