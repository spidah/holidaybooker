require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe HolidaysController do
  before do
    @user = mock('user', :id => 1, :has_role? => true)
    @holiday = mock('holiday')
    @holidays = mock('holiday', :null_object => true)
    @holidays.stub!(:find).and_return(@holiday)
    @user.stub!(:holidays).and_return(@holidays)
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
      @holidays.stub!(:size).and_return(1)
      get :index
    end

    it 'should be a success' do
      response.should be_success
    end
  end

  describe 'GET new' do
    before do
      @holidays.stub!(:after).and_return([])
      Holiday.should_receive(:new).and_return(@holiday)
      get :new
    end

    it 'should be a success' do
      response.should be_success
    end
  end

  describe 'POST create' do
    before do
      @holidays.should_receive(:build).and_return(@holiday)
    end

    it 'with valid parameters, should create a holiday and redirect' do
      @holiday.should_receive(:save).and_return(true)
      post :create
      flash[:error].should be_nil
      response.should redirect_to(holidays_url)
    end

    it 'with invalid parameters, should set an error and redirect' do
      @holiday.should_receive(:save).and_return(false)
      @holiday.should_receive(:errors).and_return('not allowed')
      post :create
      flash[:error].should eql('not allowed')
      response.should redirect_to(new_holiday_url)
    end
  end

  describe 'GET show' do
    it 'with a valid id, should be a success' do
      @holiday.should_receive(:start_date).and_return(Date.today)
      get :show, :id => 1
      response.should be_success
    end

    it 'with an invalid id, should redirect to the index page' do
      @holidays.should_receive(:find).with(1).and_raise(ActiveRecord::RecordNotFound)
      get :show, :id => 1
      flash[:error].should eql('Unable to display that holiday.')
      response.should redirect_to(holidays_url)
    end
  end

  describe 'GET edit' do
    before do
      @holiday.stub!(:start_date).and_return(Date.today)
    end

    it 'with a valid id, should be a success' do
      @holiday.should_receive(:confirmed).and_return(false)
      get :edit, :id => 1
      response.should be_success
    end

    it 'with a confirmed holiday, should redirect to the index page' do
      @holiday.should_receive(:confirmed).and_return(true)
      get :edit, :id => 1
      flash[:error].should eql('You are unable to edit a confirmed holiday. Please delete it and submit a new one.')
      response.should redirect_to(holidays_url)
    end

    it 'with an invalid id, should redirect to the index page' do
      @holidays.should_receive(:find).with(1).and_raise(ActiveRecord::RecordNotFound)
      get :edit, :id => 1
      flash[:error].should eql('Unable to edit that holiday.')
      response.should redirect_to(holidays_url)
    end
  end

  describe 'PUT update' do
    before do
      @holiday.stub!(:rejected=)
      @holiday.stub!(:rejected_reason=)
    end

    it 'with a valid holiday, should update and redirect to the unconfirmed page' do
      @holiday.should_receive(:update_attributes!).and_return(true)
      put :update, :id => 1, :holiday => {}
      response.should redirect_to(unconfirmed_holidays_url)
    end

    it 'with an invalid holiday, should redirect to the unconfirmed page' do
      @holiday.should_receive(:update_attributes!).and_raise(ActiveRecord::RecordNotSaved)
      @holiday.should_receive(:errors).and_return('not allowed')
      put :update, :id => 1, :holiday => {}
      flash[:error].should eql('not allowed')
      response.should redirect_to(unconfirmed_holidays_url)
    end

    it 'with an invalid id, should redirect to the unconfirmed page' do
      @holidays.should_receive(:find).with(1).and_raise(ActiveRecord::RecordNotFound)
      @holiday.should_not_receive(:update_attributes!)
      put :update, :id => 1, :holiday => {}
      flash[:error].should eql('Unable to update that holiday.')
      response.should redirect_to(unconfirmed_holidays_url)
    end
  end

  describe 'DELETE destroy' do
    it 'with a valid confirmed holiday, should destroy and redirect to the confirmed page' do
      @holiday.should_receive(:confirmed).and_return(true)
      @holiday.should_receive(:destroy)
      delete :destroy, :id => 1
      response.should redirect_to(confirmed_holidays_url)
    end

    it 'with a valid unconfirmed holiday, should destroy and redirect to the unconfirmed page' do
      @holiday.should_receive(:confirmed).and_return(false)
      @holiday.should_receive(:destroy)
      delete :destroy, :id => 1
      response.should redirect_to(unconfirmed_holidays_url)
    end

    it 'with an invalid id, should redirect to the index page' do
      @holidays.should_receive(:find).with(1).and_raise(ActiveRecord::RecordNotFound)
      @holiday.should_not_receive(:destroy)
      delete :destroy, :id => 1
      flash[:error].should eql('Unable to delete that holiday.')
      response.should redirect_to(holidays_url)
    end
  end

  describe 'GET confirmed' do
    it 'should be a success' do
      @holidays.should_receive(:confirmed).and_return(@holidays)
      get :confirmed
      response.should be_success
    end
  end

  describe 'GET unconfirmed' do
    it 'should be a success' do
      @holidays.should_receive(:unconfirmed).and_return(@holidays)
      get :unconfirmed
      response.should be_success
    end
  end

  describe 'GET taken' do
    it 'should be a success' do
      @holidays.should_receive(:before).and_return(@holidays)
      get :taken
      response.should be_success
    end
  end
end
