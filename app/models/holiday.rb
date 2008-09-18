class Holiday < ActiveRecord::Base
  named_scope :unconfirmed, :conditions => {:confirmed => false}
  named_scope :confirmed, :conditions => {:confirmed => true}
end
