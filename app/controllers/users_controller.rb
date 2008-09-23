class UsersController < ApplicationController
  before_filter :check_login
  before_filter :check_roles

  def index
    @confirmed = @current_user.holidays.confirmed.size
    @unconfirmed = @current_user.holidays.unconfirmed.size
  end
end
