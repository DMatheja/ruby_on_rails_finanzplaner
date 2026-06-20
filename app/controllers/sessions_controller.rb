# app/controllers/sessions_controller.rb
require "./lib/security_dictionary"

class SessionsController < ApplicationController
  skip_before_action :require_login, only: [ :new, :create, :attack ]

  def new
    @users = User.all
    @dictionary_words = SecurityDictionary::WORDS
  end

  def create
    @user = User.find_by(name: params[:user_name])

    unless @user
      redirect_to new_session_path, alert: "Benutzer nicht gefunden."
      return
    end

    # Check if user is locked out
    if @user.locked_out?
      redirect_to new_session_path, alert: "Account temporarily locked. Try again in 15 minutes."
      return
    end

    # Validate password
    if @user.authenticate(params[:password])
      @user.reset_attempts
      session[:user_id] = @user.id
      redirect_to root_path, notice: "Logged in as #{@user.name}"
    else
      @user.increment_failed_attempts
      remaining = User::MAX_ATTEMPTS - @user.failed_attempts

      if @user.locked_out?
        alert = "Too many failed attempts. Account locked for 15 minutes."
      else
        alert = "Invalid password. #{remaining} attempts remaining."
      end

      redirect_to new_session_path, alert: alert
    end
  end

  def attack
    @users = User.all
    @dictionary_words = SecurityDictionary::WORDS
    @selected_user = User.find(params[:user_id]) if params[:user_id].present?

    if request.post? && @selected_user
      attempted_password = params[:password]
      result = if @selected_user.authenticate(attempted_password)
        { success: true, message: "✓ PASSWORD CRACKED: #{attempted_password}" }
      else
        { success: false, message: "✗ Incorrect password: #{attempted_password}" }
      end

      render json: result
      nil
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to new_session_path, notice: "Logged out"
  end
end
