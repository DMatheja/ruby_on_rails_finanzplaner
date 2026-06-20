# app/controllers/categories_controller.rb
class CategoriesController < ApplicationController
  before_action :set_category, only: [:show, :edit, :update, :destroy, :mark_product_purchased, :mark_all_purchased]
  before_action :authorize_access, only: [:edit, :update, :destroy, :new, :create]

  def index
    @categories = current_user.admin? ? Category.all.includes(:user).order(:user_id) : current_user.categories
  end

  def show
    authorize_category_access
    @purchased_products = @category.products.where(status: 'purchased')
    @total_sum = @category.total_amount
    @spent_sum = @category.spent_amount
    @limit = @category.limit || 0
  end

  def new
    @category = current_user.categories.build
  end

  def create
    @category = current_user.categories.build(category_params)
    if @category.save
      redirect_to @category, notice: 'Category was successfully created.'
    else
      render :new
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize_category_access
  end

  def update
    authorize_category_access
    if @category.update(category_params)
      redirect_to @category, notice: 'Category was successfully updated.'
    else
      render :edit
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize_category_access
    @category.destroy
    redirect_to categories_url, notice: 'Category was successfully deleted.'
  end

  def mark_product_purchased
    @product = @category.products.find(params[:product_id])
    @product.update(status: 'purchased')
    redirect_to @category, notice: "✓ Bought '#{@product.name}'."
  end

  def mark_all_purchased
    @category.products.where.not(status: 'purchased').update_all(status: 'purchased')
    redirect_to @category, notice: "✓ Bought all products."
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end

  def authorize_access
    unless current_user.admin? || current_user.user?
      redirect_to root_path, alert: 'You do not have permission to create categories.'
    end
  end

  def authorize_category_access
    unless current_user.admin? || current_user.id == @category.user_id
      redirect_to root_path, alert: 'You do not have permission to access this category.'
    end
  end

  def category_params
    params.require(:category).permit(:name, :limit)
  end
end
