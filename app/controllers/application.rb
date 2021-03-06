class ApplicationController < ActionController::Base
  # Pick a unique cookie name to distinguish our session data from others
  session :session_key => '_holidays_session_id'
  # Protect from forgery with a 128 character secret
  protect_from_forgery :secret => '81207f35949092cc86f61cd33a241c1477758537a3cab36398fa173dd54389c92e08b3a6dd2022aaaa97a37128f64ef48fc5a076e844fd7bff0cc75a5c919090'

  before_filter :get_user

  # home action that is used to redirect the user to where they need to be, depending on their role
  def home
    redirect_to(login_path) and return if !@current_user
    redirect_to(admin_users_path) and return if @current_user.admin
    redirect_to(departments_path) and return if @current_user.head
    redirect_to(holidays_path)
  end

  # Filters and methods used throughout the app

  def include_extra_stylesheet(*source)
    @extra_stylesheets ||= []
    source.each { |file| @extra_stylesheets << file.to_s }
  end

  def include_extra_javascript(*source)
    @extra_javascripts ||= []
    source.each { |file| @extra_javascripts << file.to_s }
  end

  def get_user
    @current_user ||= current_user
  end

  def current_date
    Date.today
  end

  def check_login
    return true if @current_user

    store_location
    redirect_to(login_path)
  end

  def get_date
    Time.zone = 'Europe/London'
    Time.zone.now.to_date
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
