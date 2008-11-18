class Admin::AdminUsersController < ApplicationController
  needs_role :admin

  def index
    include_extra_javascript('admin/users.js')
    @users = User.pagination(params[:page], params[:sort] || 'username', params[:dir] ? 'DESC' : 'ASC')
  end

  def edit
    @user = User.find(params[:id].to_i)
    @departments = Department.find(:all)
  end

  def update
    @user = User.find(params[:id].to_i)
    user_params = params[:user]
    head = user_params[:head] == '1'
    @user.head = head
    admin = params[:admin]
    @user.admin = admin
    if params[:department]
      department = Department.find(params[:department])
      @user.department = department
    end
    @user.update_attributes(user_params)

    redirect_to(admin_users_path)
  end

  def change_head
    @user = User.find(params[:id].to_i)
    @user.head = !@user.head
    @user.save
    render(:partial => 'user_item', :layout => false, :locals => {:user => @user})
  end

  def change_admin
    @user = User.find(params[:id].to_i)
    @user.admin = !@user.admin
    @user.save
    render(:partial => 'user_item', :layout => false, :locals => {:user => @user})
  end
end
