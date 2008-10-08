class Admin::AdminDepartmentsController < ApplicationController
  needs_role :admin

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
    flash[:error] = @department.errors
    render(:action => :new)
  end

  def edit
    @department = Department.find(params[:id])
  end

  def update
    @department = Department.find(params[:id])
    @department.update_attributes(params[:department])
    redirect_to(admin_departments_path)
  rescue
    flash[:error] = @department.errors
    redirect_to(edit_admin_department_path(@department))
  end

  def destroy
    @department = Department.find(params[:id])
    @department.destroy
    redirect_to(admin_departments_path)
  rescue
    flash[:error] = 'Unable to delete the selected department'
    redirect_to(admin_departments_path)
  end
end
