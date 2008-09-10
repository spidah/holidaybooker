class Department < ActiveRecord::Base
  has_and_belongs_to_many :users
  #has_many :heads, :class_name => 'User'
end
