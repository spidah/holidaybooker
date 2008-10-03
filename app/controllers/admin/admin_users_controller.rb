class Admin::AdminUsersController < ApplicationController
  before_filter :check_login
  before_filter :check_roles

  def index
    include_extra_javascript('admin/users.js')
    @users = User.pagination(params[:page], params[:sort] || 'username', params[:dir] ? 'DESC' : 'ASC')
  end

  def change_head
    @user = User.find(params[:id])
    @user.change_head
    render(:partial => 'user_item', :layout => false, :locals => {:user => @user})
  end
end
