# app/controllers/products_controller.rb
class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  before_action :authorize_access, only: [:edit, :update, :destroy, :new, :create]

  def index
    user_category_ids = current_user.categories.pluck(:id)
    @categories = current_user.categories
    @products = Product.where('category_id IN (?) OR category_id IS NULL', user_category_ids)
  end

  def show
    authorize_product_access
  end

  def new
    @product = Product.new
    @categories = current_user.categories
  end

  def create
    @product = Product.new(product_params)
    if product_params[:category_id].present?
      category = current_user.categories.find(product_params[:category_id])
      @product.category = category
    end
    if @product.save
      redirect_to @product, notice: 'Product was successfully created.'
    else
      @categories = current_user.categories
      render :new
    end
  end

  def edit
    authorize_product_access
    @categories = current_user.categories
  end

  def update
    authorize_product_access
    if @product.update(product_params)
      redirect_to @product, notice: 'Product was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    authorize_product_access
    @product.destroy
    redirect_to products_url, notice: 'Product was successfully deleted.'
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def authorize_access
    unless current_user.admin? || current_user.user?
      redirect_to root_path, alert: 'You do not have permission to create products.'
    end
  end

  def authorize_product_access
    unless current_user.admin? || current_user.id == @product.category.user_id
      redirect_to root_path, alert: 'You do not have permission to access this product.'
    end
  end

  def product_params
    params.require(:product).permit(:name, :price, :amount, :status, :category_id)
  end
end
