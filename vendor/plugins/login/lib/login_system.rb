module LoginSystem
  def user_authenticate(username, password)
    if @user = User.authenticate(username, password)
      session[:user_id] = @user.id
      @user.updated_at = Time.now
      @user.save
    end
    @user
  end

  def current_user
    User.find(session[:user_id])
  rescue
    nil
  end
end