class Admin::AdminUsersController < ApplicationController
  before_filter :check_login
  before_filter :check_roles

  def index
    include_extra_javascript('admin/users.js')
    @users = User.pagination(params[:page], params[:sort] || 'username', params[:dir] ? 'DESC' : 'ASC')
    @admin_role = Role.get('Admin')
  end

  def edit
    @user = User.find(params[:id])
    admin_role = Role.get('Admin')
    begin
      @user.roles.find(admin_role.id)
      @admin = true
    rescue
      @admin = false
    end
    @departments = Department.find(:all)
  end

  def update
    @user = User.find(params[:id])
    user_params = params[:user]
    head = user_params[:head] == '1'
    @user.head = head
    admin = params[:admin]
    @user.admin = admin
    department = Department.find(params[:department])
    @user.department = department
    @user.update_attributes(user_params)

    redirect_to(admin_users_path)
  end

  def change_head
    @user = User.find(params[:id])
    @user.head = !@user.head
    @user.save
    render(:partial => 'user_item', :layout => false, :locals => {:user => @user})
  end

  def change_admin
    @user = User.find(params[:id])
    @admin_role = Role.get('Admin')
    admin = true if @user.roles.find(@admin_role.id) rescue false
    @user.admin = !admin
    @user.save
    render(:partial => 'user_item', :layout => false, :locals => {:user => @user})
  end
end
