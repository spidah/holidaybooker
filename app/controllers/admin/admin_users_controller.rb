class Admin::AdminUsersController < ApplicationController
  before_filter :check_login
  before_filter :check_roles

  def index
    @users = User.pagination(params[:page], params[:sort] || 'username', params[:dir] ? 'DESC' : 'ASC')
  end
end
