class UsersController < ApplicationController
  before_filter :check_login
end
