class Holiday < ActiveRecord::Base
  belongs_to :user

  before_save :count_working_days

  named_scope :unconfirmed, :conditions => {:confirmed => false}
  named_scope :confirmed, :conditions => {:confirmed => true}

  validates_presence_of :start_date, :message => 'Please select a start date.'
  validates_presence_of :end_date, :message => 'Please select an end date.'
  validates_presence_of :reason, :message => 'Please give a reason for your holiday.'

  protected
    def count_working_days
      self[:total_days] = 0
      self[:start_date].upto(self[:end_date]) { |date|
        self[:total_days] += 1 if date.wday != 0 && date.wday != 6
      }
    end
end
