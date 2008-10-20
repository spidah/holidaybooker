class HolidaysController < ApplicationController
  needs_role :user, :actions => [:index, :new, :create, :show, :edit, :update, :destroy, :confirmed, :unconfirmed, :previous, :change_month]

  def index
    date = current_date
    @confirmed = @current_user.holidays.confirmed.after(date).size
    @unconfirmed = @current_user.holidays.unconfirmed.after(date).size
    @previous = @current_user.holidays.before(date).size
  end

  def show
    include_extra_stylesheet('calendar')
    include_extra_javascript('calendar')
    @holiday = @current_user.holidays.find(params[:id])
    session[:calendar_date] = nil
    populate_vars(@holiday.start_date)
  end

  def new
    include_extra_stylesheet('calendar')
    include_extra_javascript('calendar')
    @holiday = Holiday.new
    session[:calendar_date] = nil
    populate_vars
  end

  def create
    @holiday = Holiday.new(params[:holiday])
    if @current_user.holidays << @holiday
      redirect_to(holidays_path)
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
      session[:calendar_date] = nil
      populate_vars(@holiday.start_date)
    end
  end

  def update
    @holiday = @current_user.holidays.find(params[:id])
    params[:holiday].delete(:confirmed)
    @holiday.update_attributes(params[:holiday])
    redirect_to(unconfirmed_holidays_path)
  rescue
    flash[:error] = @holiday.errors
    redirect_to(unconfirmed_holidays_path)
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

  def confirmed
    @confirmed = @current_user.holidays.confirmed.after(current_date)
  end

  def unconfirmed
    @unconfirmed = @current_user.holidays.unconfirmed.after(current_date)
  end

  def previous
    @previous = @current_user.holidays.before(current_date)
  end

  protected
    def populate_vars(startdate = current_date)
      @today = current_date
      @date = session[:calendar_date] || startdate
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
