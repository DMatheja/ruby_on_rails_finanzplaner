# app/controllers/products_controller.rb
class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  before_action :authorize_access, only: [:edit, :update, :destroy, :new, :create]

  def index
    @categories = current_user.categories
    @products = Product.joins(:category).where(categories: { user_id: current_user.id })
  end

  def show
    authorize_product_access
  end

  def new
    @product = Product.new
    @categories = current_user.categories
  end

  def create
    category = current_user.categories.find(product_params[:category_id])
    @product = category.products.build(product_params)
    if @product.save
      redirect_to @product, notice: 'Product was successfully created.'
    else
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
