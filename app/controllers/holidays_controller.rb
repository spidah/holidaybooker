class HolidaysController < ApplicationController
  before_filter :check_login
  before_filter :check_roles
end
