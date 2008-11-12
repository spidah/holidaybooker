require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe HolidaysController do
  before do
    @user = mock('user', :id => 1)
    @user.stub!(:has_role?).and_return(true)
    controller.stub!(:current_user).and_return(@user)
    login_as(@user)
  end

  describe 'should be protected' do
    it 'with an invalid user, should redirect' do
      controller.stub!(:current_user).and_return(nil)
      login_as(nil)
      get :index
      response.should be_redirect
    end

    it 'with an invalid role, should redirect' do
      @user.stub!(:has_role?).and_return(false)
      get :index
      response.should be_redirect
    end
  end

  describe 'GET index' do
    before do
      @holiday = mock('holiday', :null_object => true, :size => 1)
      @user.stub!(:holidays).and_return(@holiday)
      get :index
    end

    it 'should be a success' do
      response.should be_success
    end
  end

  describe 'GET new' do
    before do
      @holiday = mock('holiday', :null_object => true, :after => [])
      @user.stub!(:holidays).and_return(@holiday)
      Holiday.should_receive(:new).and_return(@holiday)
      get :new
    end

    it 'should be a success' do
      response.should be_success
    end
  end
end
