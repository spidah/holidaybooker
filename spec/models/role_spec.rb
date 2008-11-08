require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Role do
  before(:each) do
    @valid_attributes = {
      :name => 'role'
    }
  end

  it 'with valid attributes, should be valid' do
    role = Role.new(@valid_attributes)

    role.should be_valid
  end

  it 'with valid attributes, should create a new role' do
    Role.create!(@valid_attributes)
  end
end

describe Role, 'with fixtures loaded' do
  fixtures :roles

  it 'should have a non-empty collection of roles' do
    Role.find(:all).should_not be_empty
  end

  it 'should have 3 roles' do
    Role.find(:all).should have(3).records
  end

  it 'should find an existing role' do
    role = Role.find(roles(:admin).id)

    role.should eql(roles(:admin))
  end

  it 'should get the user role' do
    Role.get('user').should eql(roles(:user))
  end
end

describe 'User ned' do
  fixtures :users, :roles

  before(:each) do
    @ned = users(:ned)
  end

  it 'should have the user role' do
    @ned.has_role?('user').should be_true
  end

  it 'should have the head role' do
    @ned.has_role?('head').should be_true
  end

  it 'should not have the admin role' do
    @ned.has_role?('admin').should_not be_true
  end
end

describe 'User admin' do
  fixtures :users, :roles

  it 'should have the admin role' do
    users(:admin).has_role?('admin').should be_true
  end


end
