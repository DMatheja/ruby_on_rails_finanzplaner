# app/controllers/products_controller.rb
class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  before_action :authorize_access, only: [:edit, :update, :destroy, :new, :create]

  def index
    if current_user.admin?
      @categories = Category.all
      @products = Product.all.includes(category: :user)
    else
      user_category_ids = current_user.categories.pluck(:id)
      @categories = current_user.categories
      @products = Product.where('category_id IN (?) OR category_id IS NULL', user_category_ids)
    end

    if params[:category_id].present?
      @selected_category = params[:category_id]
      @products = @products.where(category_id: params[:category_id])
    end
    @products = @products.where.not(status: 'purchased')
  end

  def show
    authorize_product_access
  end

  def new
    @product = Product.new
    @categories = current_user.admin? ? Category.all.includes(:user) : current_user.categories
  end

  def create
    @product = Product.new(product_params)
    if product_params[:category_id].present?
      category = current_user.admin? ? Category.find(product_params[:category_id]) : current_user.categories.find(product_params[:category_id])
      @product.category = category
    end
    if @product.save
      redirect_to @product, notice: 'Product was successfully created.'
    else
      @categories = current_user.admin? ? Category.all.includes(:user) : current_user.categories
      render :new
    end
  end

  def edit
    authorize_product_access
    @categories = current_user.admin? ? Category.all.includes(:user) : current_user.categories
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

  def purchased
    if current_user.admin?
      @products = Product.where(status: 'purchased').includes(category: :user).order(updated_at: :desc)
    else
      user_category_ids = current_user.categories.pluck(:id)
      @products = Product.where('category_id IN (?) OR category_id IS NULL', user_category_ids).where(status: 'purchased').order(updated_at: :desc)
    end
  end

  def rebuy
    @product = Product.find(params[:id])
    authorize_product_access
    @product.update(status: 'pending')
    redirect_to purchased_products_path, notice: "↩ '#{@product.name}' was added to the shopping list."
  end

  def readd
    original = Product.find(params[:id])
    authorize_product_access_for(original)

    new_product = original.dup
    new_product.status = 'pending'
    new_product.save!

    redirect_to purchased_products_path, notice: "✚ '#{original.name}' was re-added as a new product."

  end

  def mark_purchased
    @product = Product.find(params[:id])
    authorize_product_access
    @product.update(status: 'purchased')
    redirect_to products_path, notice: "✓ '#{@product.name}' was marked as purchased."
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

  def authorize_product_access_for(product)
    unless current_user.admin? ||
      (current_user.user? && product.category&.user_id == current_user.id) ||
      (current_user.user? && product.category_id.nil?)
      redirect_to root_path, alert: 'You do not have permission to access this product.'
      end
    end


  def authorize_product_access
    unless current_user.admin? ||
      (current_user.user? && @product.category&.user_id == current_user.id) ||
      (current_user.user? && @product.category_id.nil?)
      redirect_to root_path, alert: 'You do not have permission to access this product.'
    end
  end

  def product_params
    params.require(:product).permit(:name, :price, :amount, :status, :category_id)
  end
end
