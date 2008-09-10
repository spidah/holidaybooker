class Department < ActiveRecord::Base
  has_many :users
  has_many :heads, :class_name => 'User', :conditions => {:head => true}
end
