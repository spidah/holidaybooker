require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe User, 'with fixtures loaded' do
  fixtures :users, :departments

  it 'should have a non-empty collection of users' do
    User.find(:all).should_not be_empty
  end

  it 'should have 5 users' do
    User.should have(5).records
  end

  it 'should find an existing user' do
    user = User.find(users(:ned).id)
    user.should eql(users(:ned))
  end

  it 'should have a department' do
    user = users(:ned)
    user.department.should_not be_nil
  end

  it 'should belong to the IT department' do
    user = users(:ned)
    user.department.name.should eql('IT')
  end

  it 'should return a proper fullname' do
    user = users(:ned)
    user.fullname.should eql('Ned Parker')
  end

  it 'should authenticate an existing user' do
    user = User.authenticate('ned.parker', 'password')
    user.should eql(users(:ned))
  end

  it 'should not authenticate a fake user' do
    user = User.authenticate('fake.user', 'password')
    user.should be_nil
  end

  it 'should toggle being a department head' do
    user = users(:ned)
    user.head.should be_true
    user.has_role?('head').should be_true

    user.head = false
    user.save

    user.head.should_not be_true
    user.has_role?('head').should_not be_true

    user.head = true
    user.save

    user.head.should be_true
    user.has_role?('head').should be_true
  end

  it 'should toggle being an admin' do
    user = users(:admin)
    user.has_role?('admin').should be_true

    user.admin = false
    user.save

    user.has_role?('admin').should_not be_true

    user.admin = true
    user.save

    user.has_role?('admin').should be_true
  end

  it 'should get the users for the IT department' do
    users = User.get_department_users(departments(:it))

    users.should have(2).records
    users.should include(users(:ned))
    users.should include(users(:oliver))

    users.should_not include(users(:dom))
  end
end

describe 'A new user' do
  before(:each) do
    @user = User.new
    @user.username = 'david.hayward'
    @valid_attributes = {
      :firstname => 'David',
      :surname => 'Hayward',
      :password => 'password',
      :password_confirmation => 'password'
    }
  end

  it 'with valid attributes, should be valid' do
    @user.attributes = @valid_attributes
    @user.should be_valid
  end

  it 'with valid attributes, should create a new user' do
    @user.attributes = @valid_attributes
    @user.save.should be_true
  end

  it 'without a username, should not be valid' do
    @user.username = nil
    @user.attributes = @valid_attributes

    @user.should_not be_valid
    @user.errors.on(:username).should eql('You need to enter a username.')
  end

  it 'with a strange username, should not be valid' do
    @user.username = '@~{}][;:'
    @user.attributes = @valid_attributes

    @user.should_not be_valid
    @user.errors.on(:username).should eql("Please pick a username using the following characters only: 'a'-'z', '0'-'9', '.', '_' and '-'.")
  end

  it 'with an existing username, should not be valid' do
    @user.username = 'ned.parker'
    @user.attributes = @valid_attributes

    @user.should_not be_valid
    @user.errors.on(:username).should eql('That username is already taken. Please select another one.')
  end

  it 'without a password, should not be valid' do
    @user.attributes = @valid_attributes.except(:password)
    @user.should_not be_valid
  end

  it 'without a password confirmation, should not be valid' do
    @user.attributes = @valid_attributes.except(:password_confirmation)

    @user.should_not be_valid
    @user.errors.on(:password_confirmation).should eql('Please confirm your password.')
  end

  it 'without a confirmed password, should not be valid' do
    @user.attributes = @valid_attributes
    @user.password = 'notpassword'

    @user.should_not be_valid
    @user.errors.on(:password).should eql('Please confirm your password correctly.')
  end

  it 'with a short or long password, should not be valid' do
    @user.attributes = @valid_attributes
    @user.password = '1'
    @user.password_confirmation = '1'

    @user.should_not be_valid
    @user.errors.on(:password).should eql('Please pick a password between 4 and 40 characters long.')

    @user.password = '12345678901234567890123456789012345678901'
    @user.password_confirmation = '12345678901234567890123456789012345678901'

    @user.should_not be_valid
    @user.errors.on(:password).should eql('Please pick a password between 4 and 40 characters long.')
  end
end
