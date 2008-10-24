module DepartmentsHelper
  def link_month(holiday, date, text)
    link_to(text, change_month_department_path(holiday, :date => date), :title => date, :class => 'change-month')
  end

  def replace_day(date, day)
    date.beginning_of_month + day.days - 1
  end

  def get_confirmed_holidays(user, monthstart, monthend)
    user.holidays.confirmed.in_month(monthstart, monthend).find(:all)
  end

  def colour_days(holiday, days, css_class = 'existing')
    start_date = holiday.start_date
    while start_date <= holiday.end_date do
      days[start_date.day] = {:class => css_class, :reason => holiday.reason}
      start_date += 1
    end
  end

  def populate_days(holidays, current, days)
    holidays.each { |holiday| colour_days(holiday, days) }
    colour_days(current, days, 'current') if current
  end
end
