class Admin::AdminDepartmentsController < ApplicationController
  needs_role :admin

  verify :method => :get, :only => [:index, :edit], :redirect_to => :index
  verify :method => :post, :only => [:create], :redirect_to => :index
  verify :method => :put, :only => [:update]
  verify :method => :delete, :only => :destroy, :redirect_to => :index

  def index
    @departments = Department.pagination(params[:page], params[:dir] ? 'DESC' : 'ASC')
    redirect_to(new_admin_department_path) if @departments.size == 0 && Department.all.size == 0
  end

  def new
    @department = Department.new
  end

  def create
    @department = Department.new(params[:department])
    @department.save!
    redirect_to(admin_departments_path)
  rescue
    flash.now[:error] = @department.errors
    render(:action => :new)
  end

  def edit
    @department = Department.find(params[:id].to_i)
  rescue
    flash[:error] = 'Unable to edit the selected department'
    redirect_to(admin_departments_path)
  end

  def update
    @department = Department.find(params[:id].to_i)
    @department.update_attributes!(params[:department])
    redirect_to(admin_departments_path)
  rescue ActiveRecord::RecordNotFound
    flash[:error] = 'Unable to update the selected department'
    redirect_to(admin_departments_path)
  rescue ActiveRecord::RecordNotSaved
    flash[:error] = @department.errors
    redirect_to(edit_admin_department_path(@department))
  end

  def destroy
    @department = Department.find(params[:id].to_i)
    @department.destroy
    redirect_to(admin_departments_path)
  rescue
    flash[:error] = 'Unable to delete the selected department'
    redirect_to(admin_departments_path)
  end
end
