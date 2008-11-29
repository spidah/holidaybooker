require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Holiday, 'with fixtures loaded' do
  fixtures :users, :holidays

  it 'should have a non-empty collection of holidays' do
    Holiday.find(:all).should_not be_empty
  end

  it 'should have 6 holidays' do
    Holiday.should have(6).records
  end

  it 'should find an existing holiday' do
    holiday = Holiday.find(holidays(:unconfirmed).id)

    holiday.should eql(holidays(:unconfirmed))
  end

  it 'should belong to user Ned' do
    ned = users(:ned)
    holiday = holidays(:unconfirmed)

    holiday.user.should eql(ned)
  end
end

describe Holiday, 'with a valid user' do
  fixtures :users

  before(:each) do
    @valid_attributes = {
      :start_date => Date.today,
      :end_date => Date.today + 1.week - 1.day,
      :reason => 'Test holiday'
    }
  end

  it 'with valid attributes, should be valid' do
    holiday = Holiday.new(@valid_attributes)

    holiday.should be_valid
  end

  it 'with valid attributes, should create a new holiday' do
    user = users(:ned)
    holiday = user.holidays.create!(@valid_attributes)
  end

  it 'with valid attributes, should have 5 total days' do
    user = users(:ned)
    holiday = user.holidays.create!(@valid_attributes)

    holiday.total_days.should equal(5)
  end

  it 'without a start date, should not be valid' do
    holiday = Holiday.new(@valid_attributes.except(:start_date))

    holiday.should_not be_valid
    holiday.errors.on(:start_date).should eql('Please select a start date.')
  end

  it 'without an end date, should not be valid' do
    holiday = Holiday.new(@valid_attributes.except(:end_date))

    holiday.should_not be_valid
    holiday.errors.on(:end_date).should eql('Please select an end date.')
  end

  it 'without a reason, should not be valid' do
    holiday = Holiday.new(@valid_attributes.except(:reason))

    holiday.should_not be_valid
    holiday.errors.on(:reason).should eql('Please give a reason for your holiday.')
  end
end

describe 'User Ned' do
  fixtures :users, :holidays

  before(:each) do
    @user = users(:ned)
  end

  it 'should have 5 holidays' do
    @user.holidays.should have(5).records
  end

  it 'should have 4 unconfirmed holidays' do
    @user.holidays.unconfirmed.should have(4).records
  end

  it 'should have 1 confirmed holiday' do
    @user.holidays.confirmed.should have(1).record
  end

  it 'should have 1 rejected holiday' do
    @user.holidays.rejected.should have(1).record
  end

  it 'should have 1 holiday in the past' do
    @user.holidays.before(Date.today).should have(1).record
  end

  it 'should have 3 holidays in the future' do
    @user.holidays.after(Date.today + 1.day).should have(3).records
  end

  it 'should have at least 1 holiday in the current month' do
    @user.holidays.in_month(Date.today.beginning_of_month, Date.today.end_of_month).size.should >= 1
  end

  it 'should have an unconfirmed holiday in the current month' do
    holiday = holidays(:unconfirmed)

    holiday.in_month?(Date.today).should be_true
  end

  it 'should have a future holiday not in the current month' do
    holiday = holidays(:future)

    holiday.in_month?(Date.today).should_not be_true
  end
end

describe 'User Oliver, with long holiday' do
  fixtures :users, :holidays

  before(:each) do
    @user = users(:oliver)
    @holiday = holidays(:long_holiday)
  end

  it 'should not be in next month' do
    @holiday.in_month?(Date.today + 1.month).should == false
  end

  it 'should be in four months' do
    @holiday.in_month?(Date.today + 4.months).should == true
  end

  it 'should be in five months' do
    @holiday.in_month?(Date.today + 5.months).should == true
  end

  it 'should not be in seven months' do
    @holiday.in_month?(Date.today + 7.months).should == false
  end
end
