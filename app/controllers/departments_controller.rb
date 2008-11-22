class DepartmentsController < ApplicationController
  needs_role :head

  verify :method => :get, :only => [:index, :show, :edit], :redirect_to => :index
  verify :method => :put, :only => [:update], :redirect_to => :index

  def index
    get_department_users
    @current_date = current_date
  end

  def show
    include_extra_stylesheet('gantt')
    include_extra_javascript('gantt')
    session[:calendar_date] = nil
    get_holiday
  rescue
    flash[:error] = 'Unable to display the selected holiday'
    redirect_to(departments_path)
  end

  def edit
    include_extra_stylesheet('gantt')
    include_extra_javascript('gantt')
    session[:calendar_date] = nil
    get_holiday
  rescue
    flash[:error] = 'Unable to edit the selected holiday'
    redirect_to(departments_path)
  end

  def update
    @holiday = Holiday.find(params[:id].to_i)

    if params[:holiday][:rejected] == 't'
      @holiday.rejected = true
      @holiday.rejected_reason = params[:holiday][:rejected_reason]
    else
      @holiday.confirmed = true
    end

    @holiday.save!
  rescue ActiveRecord::RecordNotFound
    flash[:error] = 'Unable to update the selected holiday'
  rescue ActiveRecord::RecordNotSaved
    flash[:error] = @holiday.errors
  ensure
    redirect_to(departments_path)
  end

  def change_month
    respond_to do |wants|
      wants.js do
        session[:calendar_date] = Date.parse(params[:date]) rescue current_date
        get_holiday
        render(:partial => 'department_gantt', :layout => false)
      end
    end
  end

  protected
    def get_holiday
      @holiday = Holiday.find(params[:id].to_i)
      get_department_users
      populate_vars(@holiday.start_date)
    end

    def get_department_users
      @users = User.get_department_users(@current_user.department)
    end

    def populate_vars(startdate = current_date)
      @today = current_date
      @date = session[:calendar_date] || startdate
      @monthstart = @date.beginning_of_month
      @monthdays = @date.end_of_month.day
      @monthend = @date.end_of_month
      @prevmonth = @date - 1.month
      @nextmonth = @date + 1.month
      @dayindex = 1
    end
end
