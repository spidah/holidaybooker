module LoginSystemTestHelper
  def login_as(user)
    @request.session[:user_id] = user ? users(user).id : nil
  end
end