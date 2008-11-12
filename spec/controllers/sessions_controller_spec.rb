require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SessionsController do
  fixtures :users

  describe 'GET new' do
    before(:each) do
      @user = mock('user')
      User.stub!(:new).and_return(@user)
    end

    it 'should create a new user object' do
      User.should_receive(:new).and_return(@user)
      get :new
    end

    it 'with a logged in user, should redirect' do
      login_as(:ned)
      get :new
      session[:user_id].should_not be_nil
      response.should be_redirect
    end
  end

  describe 'POST create' do
    before(:each) do
      @user = mock('user', :id => 1, :updated_at= => true, :save => true)
    end

    it 'with valid credentials, should login and redirect' do
      User.should_receive(:authenticate).and_return(@user)
      post :create, :username => 'username', :password => 'password'
      session[:user_id].should_not be_nil
      response.should be_redirect
    end

    it 'with invalid credentials, should redirect to login page' do
      User.should_receive(:authenticate).and_return(nil)
      post :create, :username => 'username', :password => 'password'
      session[:user_id].should be_nil
      response.should redirect_to('/login')
    end

    it 'with a logged in user, should redirect' do
      User.should_not_receive(:authenticate)
      login_as(:ned)
      post :create, :username => 'username', :password => 'password'
      response.should be_redirect
    end
  end

  describe 'DELETE destroy' do
    it 'should logout and redirect to login page' do
      login_as(:ned)
      session[:user_id].should_not be_nil
      delete :destroy
      session[:user_id].should be_nil
      response.should redirect_to('/login')
    end
  end

  describe 'POST signup' do
    before(:each) do
      @user = mock('user', :null_object => true, :id => 1)
      User.stub!(:new).and_return(@user)
    end

    it 'with valid credentials, should save and login' do
      @user.should_receive(:save).at_least(1).and_return(true)
      User.should_receive(:authenticate).and_return(@user)
      post :signup, :username => 'username', :password => 'password'
      session[:user_id].should_not be_nil
      response.should be_redirect
    end

    it 'with invalid credentials, should not save or login' do
      @user.should_receive(:save).and_return(false)
      @user.should_receive(:errors).and_return('not allowed')
      User.should_not_receive(:authenticate)
      post :signup, :username => 'username', :password => 'password'
      session[:user_id].should be_nil
      flash[:error].should eql('not allowed')
      response.should be_success
    end
  end
end
