class HolidaysController < ApplicationController
  needs_role :user

  verify :method => :get, :only => [:index, :new, :edit, :show, :change_month, :confirmed, :unconfirmed, :taken], :redirect_to => :index
  verify :method => :post, :only => [:create], :redirect_to => :index
  verify :method => :put, :only => [:update], :redirect_to => :index
  verify :method => :delete, :only => :destroy, :redirect_to => :index

  def index
    date = current_date
    @confirmed = @current_user.holidays.confirmed.after(date).size
    @unconfirmed = @current_user.holidays.unconfirmed.pending.after(date).size
    @rejected = @current_user.holidays.unconfirmed.rejected.after(date).size
  end

  def show
    include_extra_stylesheet('calendar')
    include_extra_javascript('calendar')
    @holiday = @current_user.holidays.find(params[:id].to_i)
    session[:calendar_date] = nil
    populate_vars(@holiday.start_date)
  rescue
    flash[:error] = 'Unable to display that holiday.'
    redirect_to(holidays_path)
  end

  def new
    include_extra_stylesheet('calendar')
    include_extra_javascript('calendar')
    @holiday = Holiday.new
    session[:calendar_date] = nil
    populate_vars
  end

  def create
    @holiday = @current_user.holidays.build(params[:holiday])
    if @holiday.save
      redirect_to(holidays_path)
    else
      flash[:error] = @holiday.errors
      redirect_to(new_holiday_path)
    end
  end

  def edit
    include_extra_stylesheet('calendar')
    include_extra_javascript('calendar')
    @holiday = @current_user.holidays.find(params[:id].to_i)
    if @holiday.confirmed
      flash[:error] = 'You are unable to edit a confirmed holiday. Please delete it and submit a new one.'
      redirect_to(holidays_path)
    else
      session[:calendar_date] = nil
      populate_vars(@holiday.start_date)
    end
  rescue
    flash[:error] = 'Unable to edit that holiday.'
    redirect_to(holidays_path)
  end

  def update
    @holiday = @current_user.holidays.find(params[:id].to_i)
    params[:holiday].delete(:confirmed)
    @holiday.rejected = false
    @holiday.rejected_reason = nil
    @holiday.update_attributes!(params[:holiday])
  rescue ActiveRecord::RecordNotSaved
    flash[:error] = @holiday.errors
  rescue ActiveRecord::RecordNotFound
    flash[:error] = 'Unable to update that holiday.'
  ensure
    redirect_to(unconfirmed_holidays_path)
  end

  def destroy
    @holiday = @current_user.holidays.find(params[:id].to_i)
    @holiday.destroy
    redirect_to(@holiday.confirmed ? confirmed_holidays_path : unconfirmed_holidays_path)
  rescue ActiveRecord::RecordNotFound
    flash[:error] = 'Unable to delete that holiday.'
    redirect_to(holidays_path)
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

  def taken
    @taken = @current_user.holidays.before(current_date)
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
      @confirmed = confirm_days(@current_user.holidays.confirmed.in_month(@date.beginning_of_month, @date.end_of_month).after(@today))
    end

    def convert_week_day_number(wday)
      wday > 0 ? wday : 7
    end

    def confirm_days(holidays)
      days = {}
      holidays.each { |holiday|
        start_date = holiday.start_date
        while start_date <= holiday.end_date do
          days[start_date.day] = {:class => 'confirmed', :reason => holiday.reason}
          start_date += 1
        end
      }
      days
    end
end
