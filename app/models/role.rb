class Role < ActiveRecord::Base
  has_and_belongs_to_many :users

  def self.get(name)
    find(:first, :conditions => {:name => name})
  end
end
