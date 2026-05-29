# app/controllers/subscriptions_controller.rb
class SubscriptionsController < ApplicationController
  before_action :set_subscription, only: [:show, :edit, :update, :destroy]
  before_action :authorize_access, only: [:edit, :update, :destroy, :new, :create]

  def index
    @subscriptions = current_user.subscriptions
  end

  def show
    authorize_subscription_access
  end

  def new
    @subscription = current_user.subscriptions.build
  end

  def create
    @subscription = current_user.subscriptions.build(subscription_params)
    if @subscription.save
      redirect_to @subscription, notice: 'Subscription was successfully created.'
    else
      render :new
    end
  end

  def edit
    authorize_subscription_access
  end

  def update
    authorize_subscription_access
    if @subscription.update(subscription_params)
      redirect_to @subscription, notice: 'Subscription was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    authorize_subscription_access
    @subscription.destroy
    redirect_to subscriptions_url, notice: 'Subscription was successfully deleted.'
  end

  private

  def set_subscription
    @subscription = Subscription.find(params[:id])
  end

  def authorize_access
    unless current_user.admin? || current_user.user?
      redirect_to root_path, alert: 'You do not have permission to create subscriptions.'
    end
  end

  def authorize_subscription_access
    unless current_user.admin? || current_user.id == @subscription.user_id
      redirect_to root_path, alert: 'You do not have permission to access this subscription.'
    end
  end

  def subscription_params
    params.require(:subscription).permit(:name, :price, :frequency, :start_date)
  end
end
