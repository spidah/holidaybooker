require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Department, 'with fixtures loaded' do
  fixtures :users, :departments

  it 'should have a non-empty collection of departments' do
    Department.find(:all).should_not be_empty
  end

  it 'should have 2 departments' do
    Department.find(:all).should have(2).records
  end

  it 'should find an existing department' do
    department = Department.find(departments(:it).id)
    department.should eql(departments(:it))
  end
end

describe 'IT department' do
  fixtures :users, :departments

  before(:each) do
    @it = departments(:it)
  end

  it 'should have 2 users' do
    @it.users.should have(2).records
    @it.users.should include(users(:ned))
    @it.users.should include(users(:oliver))
  end

  it 'should have 1 head' do
    @it.heads.should have(1).record
    @it.users.should include(users(:ned))
  end
end

describe Department do
  before(:each) do
    @valid_attributes = {
      :name => 'Personnel'
    }
  end

  it 'with valid attributes, should be valid' do
    department = Department.new(@valid_attributes)
    department.should be_valid
  end

  it 'with valid attributes, should create a new department' do
    Department.create!(@valid_attributes)
  end
end
