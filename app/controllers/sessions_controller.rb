class SessionsController < ApplicationController
  verify :method => :get, :only => [:new], :redirect_to => :index
  verify :method => :post, :only => [:create, :signup], :redirect_to => :index
  verify :method => :delete, :only => :destroy, :redirect_to => :index

  def new
    redirect_to(home_path) and return if @current_user
    @user = User.new
  end

  def destroy
    session[:user_id] = nil
    reset_session
    redirect_to(login_path)
  end

  def create
    redirect_to(home_path) and return if @current_user
    password_authentication(params[:username], params[:password])
  end

  def signup
    if request.post?
      user = User.new
      user.username = params[:username]
      user.attributes = params

      if user.save
        password_authentication(params[:username], params[:password])
      else
        flash[:error] = user.errors
      end
    end
  end

  protected
    def password_authentication(username, password)
      if @current_user = user_authenticate(username, password)
        successful_login
      else
        reset_session
        failed_login('Unable to log you in. Please check your username and password and try again.')
      end
    end

    def successful_login
      redirect_back_or_default(home_path)
    end

    def failed_login(message)
      flash[:error] = message
      redirect_to(login_path)
    end
end
