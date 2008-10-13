class Holiday < ActiveRecord::Base
  belongs_to :user

  before_save :count_working_days

  named_scope :unconfirmed, :conditions => {:confirmed => false}
  named_scope :confirmed, :conditions => {:confirmed => true}
  named_scope :in_month, lambda { |monthstart, monthend| {
    :conditions => ['(start_date >= :start AND start_date <= :end) OR (end_date >= :start AND end_date <= :end)',
    {:start => monthstart, :end => monthend}]
  }}

  validates_presence_of :start_date, :message => 'Please select a start date.'
  validates_presence_of :end_date, :message => 'Please select an end date.'
  validates_presence_of :reason, :message => 'Please give a reason for your holiday.'

  def in_month?(month)
    start_date = month.beginning_of_month
    end_date = month.end_of_month
    (self[:start_date] >= start_date && self[:end_date] <= end_date) || (self[:start_date] >= start_date && self[:end_date] <= end_date)
  end

  def in_date?(date)
    return self[:start_date] >= date && self[:end_date] <= date
  end

  protected
    def count_working_days
      self[:total_days] = 0
      self[:start_date].upto(self[:end_date]) { |date|
        self[:total_days] += 1 if date.wday != 0 && date.wday != 6
      }
    end
end
