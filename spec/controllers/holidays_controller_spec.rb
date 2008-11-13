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

  describe 'POST create' do
    before do
      @hol = mock('holiday')
      @holiday.should_receive(:build).and_return(@hol)
      @user.stub!(:holidays).and_return(@holiday)
    end

    it 'with valid parameters, should create a holiday and redirect' do
      @hol.should_receive(:save).and_return(true)
      post :create
      flash[:error].should be_nil
      response.should redirect_to(holidays_url)
    end

    it 'with invalid parameters, should set an error and redirect' do
      @hol.should_receive(:save).and_return(false)
      @hol.should_receive(:errors).and_return('not allowed')
      post :create
      flash[:error].should eql('not allowed')
      response.should redirect_to(new_holiday_url)
    end
  end

  describe 'GET show' do
    it 'with a valid id, should be a success' do
      @holiday.should_receive(:find).with(1).and_return(@holiday)
      @holiday.should_receive(:start_date).and_return(Date.today)
      get :show, :id => 1
      response.should be_success
    end

    it 'with an invalid id, should redirect to the index page' do
      @holiday.should_receive(:find).with(1).and_raise(ActiveRecord::RecordNotFound)
      get :show, :id => 1
      flash[:error].should eql('Unable to display that holiday.')
      response.should redirect_to(holidays_url)
    end
  end
end
