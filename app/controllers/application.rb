class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # Pick a unique cookie name to distinguish our session data from others
  session :session_key => '_holidays_session_id'
  # Protect from forgery with a 128 character secret
  protect_from_forgery :secret => '81207f35949092cc86f61cd33a241c1477758537a3cab36398fa173dd54389c92e08b3a6dd2022aaaa97a37128f64ef48fc5a076e844fd7bff0cc75a5c919090'

  before_filter :get_user
  before_filter :check_roles

  # Filters used throughout the app

  def get_user
    begin
      @current_user ||= User.find(session[:user_id])
    rescue
      @current_user = nil
    end
  end

  def check_login
    return true if @current_user

    store_location
    redirect_to(login_path)
  end

  def check_roles
    if @current_user
      return true if @current_user.roles.detect {|role|
        role.rights.detect {|right|
          right.action == action_name && right.controller == controller_path
        }
      }

      redirect_to(request.request_uri)
    end
  end

  def store_location
    session[:return_to] = request.request_uri
  end

  def redirect_back_or_default(default)
    if session[:return_to].nil?
      redirect_to(default)
    else
      redirect_to(session[:return_to])
      session[:return_to] = nil
    end
  end
end
