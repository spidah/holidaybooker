class Department < ActiveRecord::Base
  has_many :users
  has_many :heads, :class_name => 'User', :conditions => {:head => true}

  def self.pagination(page, dir = 'ASC')
    paginate(:page => page, :per_page => 50, :order => "name #{dir}")
  end
end
