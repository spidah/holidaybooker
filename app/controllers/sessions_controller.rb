class SessionsController < ApplicationController
  def new
    @user = User.new
  end

  def destroy
    session[:user_id] = nil
    reset_session
    redirect_to(login_path)
  end

  def create
    if @current_user
      if @current_user.has_role?('admin')
        redirect_to(admin_users_path)
      else
        redirect_to(home_path)
      end

      return
    end

    password_authentication(params[:username], params[:password])
  end

  def signup
    if request.post?
      user = User.new
      user.username = params[:username]
      user.password = params[:password]
      user.password_confirmation = params[:password_confirmation]
      user.firstname = params[:firstname]
      user.surname = params[:surname]
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
      if @current_user.has_role?('admin')
        redirect_back_or_default(admin_users_path)
      else
        redirect_back_or_default(home_path)
      end
    end

    def failed_login(message)
      flash[:error] = message
      redirect_to(login_path)
    end
end
