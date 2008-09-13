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
    redirect_to(home_path) and return if @current_user

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
      if @user = User.authenticate(username, password)
        session[:user_id] = @user.id
        @user.updated_at = Time.now
        @user.save
        successful_login
      else
        reset_session
        failed_login('Unable to log you in. Please check your username and password and try again.')
      end
    end

    def successful_login
      redirect_back_or_default(user_path)
    end

    def failed_login(message)
      flash[:error] = message
      redirect_to(login_path)
    end
end
