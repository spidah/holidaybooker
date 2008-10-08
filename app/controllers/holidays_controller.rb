class HolidaysController < ApplicationController
  needs_role :admin
  needs_role :user, :actions => [:new, :create, :show, :edit, :update, :destroy, :submitted, :confirmed, :unconfirmed, :change_month]

  def show
    include_extra_stylesheet('calendar')
    include_extra_javascript('calendar')
    @holiday = @current_user.holidays.find(params[:id])
    populate_vars(@holiday.start_date)
  end

  def new
    include_extra_stylesheet('calendar')
    include_extra_javascript('calendar')
    @holiday = Holiday.new
    populate_vars
  end

  def create
    @holiday = Holiday.new(params[:holiday])
    if @current_user.holidays << @holiday
      redirect_to(home_path)
    else
      flash[:error] = @holiday.errors
      redirect_to(new_holiday_path)
    end
  end

  def edit
    include_extra_stylesheet('calendar')
    include_extra_javascript('calendar')
    @holiday = @current_user.holidays.find(params[:id])
    if @holiday.confirmed
      flash[:error] = 'You are unable to edit a confirmed holiday. Please delete it and submit a new one.'
      redirect_to(holidays_path)
    else
      populate_vars(@holiday.start_date)
    end
  end

  def destroy
    @holiday = @current_user.holidays.find(params[:id])
    confirmed = @holiday.confirmed
    @holiday.destroy
    redirect_to(confirmed ? confirmed_holidays_path : unconfirmed_holidays_path)
  end

  def change_month
    session[:calendar_date] = Date.parse(params[:date]) rescue current_date
    respond_to do |wants|
      wants.html do
        redirect_to(new_holiday_path)
      end
      wants.js do
        populate_vars
        render :partial => 'holiday_calendar', :layout => false
      end
    end
  end

  def submitted
    @confirmed = @current_user.holidays.confirmed.size
    @unconfirmed = @current_user.holidays.unconfirmed.size
  end

  def confirmed
    @confirmed = @current_user.holidays.confirmed
  end

  def unconfirmed
    @unconfirmed = @current_user.holidays.unconfirmed
  end

  protected
    def populate_vars(date = current_date)
      @today = date
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
