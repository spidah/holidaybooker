class HolidaysController < ApplicationController
  before_filter :check_login
  before_filter :check_roles

  def new
    include_extra_stylesheet('new-calendar')
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

  protected
    def convert_week_day_number(wday)
      wday > 0 ? wday : 7
    end
end
