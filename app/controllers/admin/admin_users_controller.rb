class Admin::AdminUsersController < ApplicationController
  def index
    @users = User.find(:all)
  end
end
