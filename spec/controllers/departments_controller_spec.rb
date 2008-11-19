require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe DepartmentsController do
  before do
    @user = mock('user', :id => 1, :has_role? => true, :department => 1)
    User.stub!(:get_department_users).with(1).and_return([@user])
    @holiday = mock('holiday', :start_date => nil)
    Holiday.stub!(:find).with(1).and_return(@holiday)
    controller.stub!(:current_user).and_return(@user)
    controller.stub!(:populate_vars)
    controller.stub!(:get_department_users)
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
    it 'should be a success' do
      get :index
      response.should be_success
    end

    it 'should get the department users' do
      controller.should_receive(:get_department_users)
      get :index
    end
  end

  describe 'GET show' do
    it 'with a valid id, should be a success' do
      get :show, :id => 1
      response.should be_success
    end

    it 'with an invalid id, should set an error and redirect to the index page' do
      Holiday.should_receive(:find).with(1).and_raise(ActiveRecord::RecordNotFound)
      get :show, :id => 1
      flash[:error] = 'Unable to display the selected holiday'
      response.should redirect_to(departments_path)
    end
  end

  describe 'GET edit' do
    it 'with a valid id, should be a success' do
      get :edit, :id => 1
      response.should be_success
    end

    it 'with an invalid id, should set an error and redirect to the index page' do
      Holiday.should_receive(:find).with(1).and_raise(ActiveRecord::RecordNotFound)
      get :edit, :id => 1
      flash[:error] = 'Unable to edit the selected holiday'
      response.should redirect_to(departments_path)
    end
  end

  describe 'PUT update' do
    it 'with a valid confirmed holiday, should confirm the holiday and redirect to the index page' do
      @holiday.should_receive(:confirmed=).with(true)
      @holiday.should_receive(:save!)
      put :update, :id => 1, :holiday => {}
      flash[:error].should be_nil
      response.should redirect_to(departments_path)
    end

    it 'with a valid rejected holiday, should reject the holiday and redirect to the index page' do
      @holiday.should_receive(:rejected=).with(true)
      @holiday.should_receive(:rejected_reason=).with('test')
      @holiday.should_receive(:save!)
      put :update, :id => 1, :holiday => {:rejected => 't', :rejected_reason => 'test'}
      flash[:error].should be_nil
      response.should redirect_to(departments_path)
    end

    it 'with an invalid id, should set an error and redirect to the index page' do
      Holiday.should_receive(:find).with(1).and_raise(ActiveRecord::RecordNotFound)
      @holiday.should_not_receive(:save!)
      put :update, :id => 1, :holiday => {}
      flash[:error].should eql('Unable to update the selected holiday')
      response.should redirect_to(departments_path)
    end
  end
end
