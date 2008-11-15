require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Admin::AdminDepartmentsController do
  before do
    @user = mock('user', :id => 1, :has_role? => true)
    controller.stub!(:current_user).and_return(@user)
    @department = mock('department')
  end

  it 'with an invalid user, should redirect' do
    controller.stub!(:current_user).and_return(nil)
    get :index
    response.should be_redirect
  end

  it 'with an invalid role, should redirect' do
    @user.should_receive(:has_role?).with('admin').and_return(false)
    get :index
    response.should be_redirect
  end

  describe 'GET index' do
    before do
      Department.stub!(:pagination).and_return([@department])
    end

    it 'should be a success' do
      get :index
      response.should be_success
    end

    it 'should do ascending pagination' do
      Department.should_receive(:pagination).with(anything, 'ASC').and_return([@department])
      get :index
      response.should be_success
    end

    it 'should do descending pagination' do
      Department.should_receive(:pagination).with(anything, 'DESC').and_return([@department])
      get :index, :dir => 'down'
      response.should be_success
    end

    it 'with no departments, should redirect to the new department page' do
      @departments = mock('department')
      @departments.should_receive(:size).at_least(1).and_return(0)
      Department.should_receive(:pagination).and_return(@departments)
      Department.should_receive(:all).and_return(@departments)
      get :index
      response.should redirect_to(new_admin_department_url)
    end
  end

  describe 'GET new' do
    it 'should be a success' do
      Department.should_receive(:new).and_return(@department)
      get :new
      response.should be_success
    end
  end

  describe 'POST create' do
    before do
      Department.stub!(:new).and_return(@department)
    end

    it 'with valid parameters, should create a department and redirect to the index page' do
      @department.should_receive(:save!)
      post :create
      response.should redirect_to(admin_departments_url)
    end

    it 'with invalid parameters, should set and error and show the new department page' do
      @department.should_receive(:save!).and_raise(ActiveRecord::RecordNotSaved)
      @department.should_receive(:errors).and_return('not allowed')
      post :create
      flash[:error].should eql('not allowed')
      response.should render_template(:new)
    end
  end
end
