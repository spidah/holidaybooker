class DepartmentsController < ApplicationController
  needs_role :head

  def index
    get_department_users
  end

  def edit
    if action_name == 'edit'
      include_extra_stylesheet('gantt')
      include_extra_javascript('gantt')
      session[:calendar_date] = nil
    end
    @holiday = Holiday.find(params[:id])
    get_department_users
    populate_vars(@holiday.start_date)
  end

  def change_month
    respond_to do |wants|
      wants.js do
        session[:calendar_date] = Date.parse(params[:date]) rescue current_date
        edit
        render(:partial => 'department_gantt', :layout => false)
      end
    end
  end

  protected
    def get_department_users
      @users = User.get_department_users(@current_user.department)
    end

    def populate_vars(startdate = current_date)
      @today = current_date
      @date = session[:calendar_date] || startdate
      #@weekday = convert_week_day_number(@date.wday)
      @monthstart = @date.beginning_of_month
      @monthdays = @date.end_of_month.day
      @monthend = @date.end_of_month
      @prevmonth = @date - 1.month
      @nextmonth = @date + 1.month
      @dayindex = 1
      #@weekindex = 1
    end
end
