class Admin::AdminUsersController < ApplicationController
  needs_role :admin

  def index
    include_extra_javascript('admin/users.js')
    @users = User.pagination(params[:page], params[:sort] || 'username', params[:dir] ? 'DESC' : 'ASC')
  end

  def edit
    @user = User.find(params[:id].to_i)
    @departments = Department.find(:all)
  rescue
    flash[:error] = 'Unable to edit the selected user'
    redirect_to(admin_users_path)
  end

  def update
    @user = User.find(params[:id].to_i)
    uparams = params[:user]
    @user.head = uparams[:head] == '1'
    @user.admin = uparams[:admin] == '1'
    @user.department = Department.find(uparams[:department].to_i) if uparams[:department]
    @user.update_attributes!(uparams.except(:head).except(:admin).except(:department))

    redirect_to(admin_users_path)
  rescue ActiveRecord::RecordNotFound
    flash[:error] = 'Unable to update the selected user'
    redirect_to(admin_users_path)
  rescue ActiveRecord::RecordNotSaved
    flash.now[:error] = @user.errors
    render(:action => 'edit')
  end

  def destroy
    @user = User.find(params[:id].to_i)
    @user.destroy
  rescue
    flash[:error] = 'Unable to delete the selected user'
  ensure
    redirect_to(admin_users_path)
  end

  def change_head
    @user = User.find(params[:id].to_i)
    @user.head = !@user.head
    @user.save!
    render(:partial => 'user_item', :layout => false, :locals => {:user => @user})
  rescue ActiveRecord::RecordNotFound
    flash[:error] = 'Unable to update the selected user'
    redirect_to(admin_users_path)
  rescue ActiveRecord::RecordNotSaved
    flash[:error] = 'Unable to change the head value for the selected user'
    redirect_to(admin_users_path)
  end

  def change_admin
    @user = User.find(params[:id].to_i)
    @user.admin = !@user.admin
    @user.save!
    render(:partial => 'user_item', :layout => false, :locals => {:user => @user})
  rescue ActiveRecord::RecordNotFound
    flash[:error] = 'Unable to update the selected user'
    redirect_to(admin_users_path)
  rescue ActiveRecord::RecordNotSaved
    flash[:error] = 'Unable to change the admin value for the selected user'
    redirect_to(admin_users_path)
  end
end
