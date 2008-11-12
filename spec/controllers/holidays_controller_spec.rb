require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe HolidaysController do
  before do
    @user = mock('user', :id => 1, :has_role? => true)
    @holiday = mock('holiday', :null_object => true)
    @user.stub!(:holidays).and_return(@holiday)
    controller.stub!(:current_user).and_return(@user)
    login_as(@user)
  end

  it 'with an invalid user, should redirect' do
    controller.stub!(:current_user).and_return(nil)
    get :index
    response.should be_redirect
  end

  it 'with an invalid role, should redirect' do
    @user.stub!(:has_role?).and_return(false)
    get :index
    response.should be_redirect
  end

  describe 'GET index' do
    before do
      @holiday.stub!(:size).and_return(1)
      get :index
    end

    it 'should be a success' do
      response.should be_success
    end
  end

  describe 'GET new' do
    before do
      @holiday.stub!(:after).and_return([])
      Holiday.should_receive(:new).and_return(@holiday)
      get :new
    end

    it 'should be a success' do
      response.should be_success
    end
  end
end
