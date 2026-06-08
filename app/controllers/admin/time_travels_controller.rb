module Admin
  class TimeTravelsController < ApplicationController
    before_action :require_admin
 
    def show
      @simulated_time = session[:simulated_time]
        &.then { |t| Time.parse(t) }
    end

    def update
      target = Time.parse(params[:target_time])
      session[:simulated_time] = target.iso8601
      Timecop.travel(target)
      redirect_to admin_time_travel_path,
        notice: "Zeit gesetzt auf: #{target.strftime('%d.%m.%Y %H:%M')}"
    end
 
    def destroy
      session.delete(:simulated_time)
      Timecop.return
      redirect_to admin_time_travel_path,
        notice: 'Echtzeit wiederhergestellt.'
    end
 
    private
 
    def require_admin
      unless current_user&.admin?
        redirect_to root_path, alert: 'Kein Zugriff.'
      end
    end
  end
end
