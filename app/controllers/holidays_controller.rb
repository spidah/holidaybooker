class HolidaysController < ApplicationController
  before_filter :check_login
  before_filter :check_roles

  def new
    include_extra_stylesheet('new-holiday')
    include_extra_javascript('new-holiday')
    @holiday = Holiday.new
    populate_vars
  end

  def create
    @holiday = Holiday.new(params[:holiday])
    if @current_user.holidays << @holiday
      redirect_to(user_path)
    else
      flash[:error] = @holiday.errors
      redirect_to(new_holiday_path)
    end
  end

  def change_month
    session[:calendar_date] = Date.parse(params[:date]) rescue current_date
    respond_to do |wants|
      wants.html do
        redirect_to(new_holiday_path)
      end
      wants.js do
        populate_vars
        render :partial => 'new_holiday_calendar', :layout => false
      end
    end
  end

  protected
    def populate_vars
      @today = current_date
      @date = session[:calendar_date] || @today
      @weekday = convert_week_day_number(@date.wday)
      @monthstart = convert_week_day_number(@date.beginning_of_month.wday)
      @monthdays = @date.end_of_month.day
      @monthend = convert_week_day_number(@date.end_of_month.wday)
      @prevmonth = @date - 1.month
      @nextmonth = @date + 1.month
      @dayindex = 1
      @weekindex = 1
    end

    def convert_week_day_number(wday)
      wday > 0 ? wday : 7
    end
end
