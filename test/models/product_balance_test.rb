require "test_helper"

class ProductBalanceTest < ActiveSupport::TestCase
  setup do
    @user = User.create!(
      name: "TestUser",
      password: "password",
      balance: 10000,
    )
    @category = Category.create!(name: "Tech", user: @user)
  end

  test "deducts balance on create if status is purchased" do
    Product.create!(name: "Laptop", price: 1000, category: @category, status: "purchased")
    @user.reload
    assert_equal 9000.0, @user.balance
  end

  test "does not deduct balance on create if status is pending" do
    Product.create!(name: "Laptop", price: 1000, category: @category, status: "pending")
    @user.reload
    assert_equal 10000.0, @user.balance
  end

  test "deducts balance on update to purchased" do
    product = Product.create!(name: "Laptop", price: 1000, category: @category, status: "pending")
    product.update!(status: "purchased")
    @user.reload
    assert_equal 9000.0, @user.balance
  end
end
