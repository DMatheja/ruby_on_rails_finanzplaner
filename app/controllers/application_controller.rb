class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  helper_method :current_user
  
  around_action :handle_time_travel
  before_action :require_login
  before_action :process_finances
  before_action :track_last_visit

  private

  def handle_time_travel
    if session[:simulated_time].present?
      Timecop.travel(Time.parse(session[:simulated_time])) do
        yield
      end
    else
      yield
    end
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def process_finances
    FinanceProcessor.process(current_user) if current_user
  end

  def require_login
    unless current_user
      redirect_to new_session_path, alert: "Please log in first"
    end
  end

  def track_last_visit
    return unless current_user
    page_name = case request.path
                when root_path          then 'Dashboard'
                when products_path      then 'Products'
                when categories_path    then 'Categories'
                when subscriptions_path then 'Subscriptions'
                else request.path
                end
    current_user.update_columns(
      last_visited_at:   Time.current,
      last_visited_page: page_name
    )
  end
end
