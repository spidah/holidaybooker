module LoginSystemTestHelper
  def login_as(user)
    @request.session[:user_id] = user ? (Symbol === user ? users(user).id : user.id) : nil
  end
end
