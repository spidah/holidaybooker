module HolidaysHelper
  def link_month(date, text)
    link_to(text, change_month_holidays_path(:date => date), :id => date, :class => 'change-month')
  end

  def replace_day(date, day)
    date.beginning_of_month + day.days - 1
  end

  def date_id(date)
    date.strftime('%d%m%Y')
  end
end
