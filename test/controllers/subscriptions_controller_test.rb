require "test_helper"

class SubscriptionsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = User.create!(name: "subtester", password: "password123", password_confirmation: "password123", role: 1, balance: 1000.0, income: 2000.0, income_day: 1)
    post sessions_path, params: { user_id: @user.id, password: "password123" }
  end

  test "invalid subscription creation returns validation errors" do
    post subscriptions_path, params: {
      subscription: {
        name: "",
        price: "",
        frequency: "monthly",
        start_date: Date.current,
        billing_day: 1,
        subscription_type: "platform",
        quantity: 1
      }
    }

    assert_response :unprocessable_entity
    assert_select "h4", text: /error/
  end

  test "user can create, edit, and delete a subscription" do
    assert_difference("Subscription.count", 1) do
      post subscriptions_path, params: {
        subscription: {
          name: "Netflix",
          price: 9.99,
          frequency: "monthly",
          start_date: Date.current,
          billing_day: 1,
          subscription_type: "platform",
          quantity: 1
        }
      }
    end

    subscription = Subscription.last
    assert_redirected_to subscription_path(subscription)

    follow_redirect!
    assert_response :success
    assert_select "h2", text: /Netflix/

    get edit_subscription_path(subscription)
    assert_response :success

    patch subscription_path(subscription), params: {
      subscription: {
        name: "Netflix Premium",
        price: 12.99,
        frequency: "monthly",
        start_date: Date.current,
        billing_day: 15,
        subscription_type: "platform",
        quantity: 1
      }
    }

    assert_redirected_to subscription_path(subscription)
    assert_equal "Netflix Premium", subscription.reload.name

    assert_difference("Subscription.count", -1) do
      delete subscription_path(subscription)
    end

    assert_redirected_to subscriptions_path
  end

  test "subscription delete links use Turbo-compatible delete behavior" do
    subscription = @user.subscriptions.create!(name: "Spotify", price: 4.99, frequency: "monthly", start_date: Date.current, billing_day: 1, subscription_type: "platform", quantity: 1)

    get subscriptions_path
    assert_response :success
    assert_select "a[href='#{subscription_path(subscription)}'][data-turbo-method='delete']", text: "Delete"
  end
end
