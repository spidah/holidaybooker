require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Admin::AdminUsersController do
  before do
    @currentuser = mock('user', :id => 1, :has_role? => true)
    controller.stub!(:current_user).and_return(@currentuser)
    @user = mock('user')
    User.stub!(:find).with(1).and_return(@user)
    @admin_role = mock('role')
    Role.stub!(:get).with('admin').and_return(@admin_role)
    @department = mock('department')
    Department.stub!(:find).with(:all).and_return([@department])
  end

  it 'with an invalid user, should redirect' do
    controller.stub!(:current_user).and_return(nil)
    get :index
    response.should be_redirect
  end

  it 'with an invalid role, should redirect' do
    @currentuser.should_receive(:has_role?).with('admin').and_return(false)
    get :index
    response.should be_redirect
  end

  describe 'GET index' do
    before do
      User.stub!(:pagination).and_return([@user])
      controller.stub!(:get_departments_as_json)
    end

    it 'should be a success' do
      get :index
      response.should be_success
    end

    it 'should do ascending pagination' do
      User.should_receive(:pagination).with(anything, anything, 'ASC').and_return([@user])
      get :index
      response.should be_success
    end

    it 'should do descending pagination' do
      User.should_receive(:pagination).with(anything, anything, 'DESC').and_return([@user])
      get :index, :dir => 'down'
      response.should be_success
    end
  end

  describe 'GET edit' do
    it 'with a valid id, should be a success' do
      get :edit, :id => 1
      flash[:error].should be_nil
      response.should be_success
    end

    it 'with an invalid id, should set an error and redirect to the index page' do
      User.should_receive(:find).with(1).and_raise(ActiveRecord::RecordNotFound)
      get :edit, :id => 1
      flash[:error].should eql('Unable to edit the selected user')
      response.should redirect_to(admin_users_url)
    end
  end

  describe 'PUT update' do
    before do
      @user.stub!(:head=)
      @user.stub!(:admin=)
      @user.stub!(:department=)
    end

    it 'with valid parameters, should redirect to the index page' do
      @user.should_receive(:update_attributes!)
      put :update, :id => 1, :user => {}
      flash[:error].should be_nil
      response.should redirect_to(admin_users_url)
    end

    it 'with invalid parameters, should set an error and render the edit action' do
      @user.should_receive(:update_attributes!).and_raise(ActiveRecord::RecordNotSaved)
      @user.should_receive(:errors).and_return('not allowed')
      put :update, :id => 1, :user => {}
      flash[:error].should eql('not allowed')
      response.should render_template(:edit)
    end

    it 'with an invalid id, should set an error and redirect to the index page' do
      User.should_receive(:find).with(1).and_raise(ActiveRecord::RecordNotFound)
      @user.should_not_receive(:update_attributes!)
      put :update, :id => 1, :user => {}
      flash[:error].should eql('Unable to update the selected user')
      response.should redirect_to(admin_users_url)
    end
  end

  describe 'DELETE destroy' do
    it 'with a valid id, should destroy and redirect to the index page' do
      @user.should_receive(:destroy)
      delete :destroy, :id => 1
      flash[:error].should be_nil
      response.should redirect_to(admin_users_url)
    end

    it 'with an invalid id, should set an error and redirect to the index page' do
      User.should_receive(:find).with(1).and_raise(ActiveRecord::RecordNotFound)
      delete :destroy, :id => 1
      flash[:error].should eql('Unable to delete the selected user')
      response.should redirect_to(admin_users_url)
    end
  end

  describe 'PUT change_head' do
    it 'with a head user, should remove head status and render the user partial' do
      @user.should_receive(:head).and_return(true)
      @user.should_receive(:head=).with(false)
      put :change_head, :id => 1
      response.should render_template(:user_item)
    end

    it 'with a non-head user, should add head status and render the user partial' do
      @user.should_receive(:head).and_return(false)
      @user.should_receive(:head=).with(true)
      put :change_head, :id => 1
      response.should render_template(:user_item)
    end

    it 'with an invalid id, should set an error and redirect to the index page' do
      User.should_receive(:find).with(1).and_raise(ActiveRecord::RecordNotFound)
      @user.should_not_receive(:head=)
      put :change_head, :id => 1
      response.response_code.should == 404
    end
  end

  describe 'PUT change_admin' do
    it 'with an admin user, should remove admin status and render the user partial' do
      admin = mock('user')
      User.should_receive(:find).with(2).and_return(admin)
      admin.should_receive(:admin).and_return(true)
      admin.should_receive(:admin=).with(false)
      put :change_admin, :id => 2
      response.should render_template(:user_item)
    end

    it 'with a non-admin user, should add admin status and render the user partial' do
      nonadmin = mock('user')
      User.should_receive(:find).with(2).and_return(nonadmin)
      nonadmin.should_receive(:admin).and_return(false)
      nonadmin.should_receive(:admin=).with(true)
      put :change_admin, :id => 2
      response.should render_template(:user_item)
    end

    it 'with an invalid id, should return a 404 status' do
      User.should_receive(:find).with(2).and_raise(ActiveRecord::RecordNotFound)
      @user.should_not_receive(:admin=)
      put :change_admin, :id => 2
      response.response_code.should == 404
    end
  end

  describe 'PUT change_department' do
    it 'with a valid department, should set the department, save, and render the user partial' do
      Department.should_receive(:find).with(1).and_return(@department)
      @user.should_receive(:department=)
      @user.should_receive(:save!)
      put :change_department, :id => 1, :department => 1
      response.should render_template(:user_item)
    end

    it 'with an invalid department, should return a 404 status' do
      Department.should_receive(:find).with(1).and_raise(ActiveRecord::RecordNotFound)
      @user.should_not_receive(:department=)
      @user.should_not_receive(:save!)
      put :change_department, :id => 1, :department => 1
      response.response_code.should == 404
    end

    it 'with an invalid user, should return a 404 status' do
      User.should_receive(:find).with(1).and_raise(ActiveRecord::RecordNotFound)
      @user.should_not_receive(:department=)
      @user.should_not_receive(:save!)
      put :change_department, :id => 1, :department => 1
      response.response_code.should == 404
    end
  end
end
