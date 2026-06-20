# app/controllers/users_controller.rb
class UsersController < ApplicationController
  before_action :set_user, only: [ :show, :edit, :update, :destroy ]
  before_action :authorize_access, only: [ :edit, :update, :destroy, :index ]

  def dashboard
    @user = current_user
    @categories = @user.categories.includes(:products)

    # Daten für Kategorie-Ausgaben-Chart
    @chart_labels = @categories.map(&:name).to_json
    @chart_spent  = @categories.map(&:spent_amount).to_json
    @chart_limits = @categories.map { |c| c.limit || 0 }.to_json

    # Monatliche Subscription-Kosten
    @monthly_subscriptions = @user.subscriptions
      .where(frequency: "monthly")
      .sum(:price)
    @weekly_subscriptions = @user.subscriptions
      .where(frequency: "weekly")
      .sum(:price) * 4
  end

  def index
    @users = User.all
  end

  def show
    authorize_user_access
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to @user, notice: "User was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize_user_access
  end

  def update
    authorize_user_access
    if @user.update(user_params)
      redirect_to @user, notice: "User was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize_user_access
    @user.destroy
    redirect_to users_url, notice: "User was successfully deleted."
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def authorize_access
    unless current_user.admin?
      redirect_to root_path, alert: "You do not have permission to perform this action."
    end
  end

  def authorize_user_access
    unless current_user.admin? || current_user.id == @user.id
      redirect_to root_path, alert: "You can only edit your own profile."
    end
  end

  def user_params
    params.require(:user).permit(:name, :password, :balance, :income, :income_day, :role)
  end
end
