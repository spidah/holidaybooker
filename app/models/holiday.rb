class Holiday < ActiveRecord::Base
  belongs_to :user

  before_save :count_working_days

  named_scope :unconfirmed, :conditions => {:confirmed => false}
  named_scope :confirmed, :conditions => {:confirmed => true}
  named_scope :pending, :conditions => {:rejected => false}
  named_scope :rejected, :conditions => {:rejected => true}
  named_scope :in_month, lambda { |monthstart, monthend|
    { :conditions => [ '(start_date >= :start AND start_date <= :end) OR (end_date >= :start AND end_date <= :end)',
      { :start => monthstart, :end => monthend } ] }
  }
  named_scope :before, lambda { |date|
    { :conditions => [ 'end_date <= :date', { :date => date } ] }
  }
  named_scope :after, lambda { |date|
    { :conditions => [ 'start_date >= :date', { :date => date } ] }
  }

  validates_presence_of :start_date, :message => 'Please select a start date.'
  validates_presence_of :end_date, :message => 'Please select an end date.'
  validates_presence_of :reason, :message => 'Please give a reason for your holiday.'

  def in_month?(month)
    @months ||= begin
      sdate = self[:start_date]
      edate = self[:end_date]
      arr = []
      while sdate.month <= edate.month && sdate.year <= edate.year do
        arr << "#{sdate.month}#{sdate.year}"
        sdate += 1.month
      end
      arr
    end
    @months.include?("#{month.month}#{month.year}")
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
