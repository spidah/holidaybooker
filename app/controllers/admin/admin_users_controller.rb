class Admin::AdminUsersController < ApplicationController
  def index
    @users = User.pagination(params[:page], params[:sort] || 'username', params[:dir] ? 'DESC' : 'ASC')
  end
end
