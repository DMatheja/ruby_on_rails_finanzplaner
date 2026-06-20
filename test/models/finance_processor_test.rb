require "test_helper"

class FinanceProcessorTest < ActiveSupport::TestCase
  setup do
    @user = User.create!(
      name: "TestUser",
      password: "password",
      income: 1000,
      income_day: 5,
      balance: 10000,
      last_processed_date: Date.new(2026, 6, 1)
    )

    @subscription = @user.subscriptions.create!(
      name: "Netflix",
      price: 15,
      frequency: "monthly",
      start_date: Date.new(2026, 6, 1),
      billing_day: 10,
      subscription_type: "platform"
    )

    @weekly_sub = @user.subscriptions.create!(
      name: "Box",
      price: 20,
      frequency: "weekly",
      start_date: Date.new(2026, 6, 3), # Wednesday
      billing_day: 1, # Not really used for weekly
      subscription_type: "regular",
      quantity: 1
    )
  end

  test "processes income correctly" do
    travel_to Date.new(2026, 6, 6) do
      FinanceProcessor.process(@user)
      @user.reload

      # balance starts at 10000
      # income day is 5, between June 1 and June 6 -> +1000
      # weekly sub on June 3 (Wed) -> -20
      # Expected: 10000 + 1000 - 20 = 10980
      assert_equal 10980.0, @user.balance
      assert_equal Date.new(2026, 6, 6), @user.last_processed_date
    end
  end

  test "processes subscription correctly" do
    travel_to Date.new(2026, 6, 11) do
      FinanceProcessor.process(@user)
      @user.reload

      # balance starts at 10000
      # income day is 5 -> +1000
      # netflix billing day 10 -> -15
      # weekly sub on June 3 (Wed) -> -20
      # weekly sub on June 10 (Wed) -> -20
      # Expected: 10000 + 1000 - 15 - 20 - 20 = 10945
      assert_equal 10945.0, @user.balance
      assert_equal Date.new(2026, 6, 11), @user.last_processed_date
    end
  end

  test "does not process multiple times for the same day" do
    travel_to Date.new(2026, 6, 11) do
      FinanceProcessor.process(@user)

      initial_balance = @user.reload.balance

      # Process again
      FinanceProcessor.process(@user)

      assert_equal initial_balance, @user.reload.balance
    end
  end
end
