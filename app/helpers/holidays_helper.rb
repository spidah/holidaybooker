module HolidaysHelper
  def link_month(date, text)
    link_to(text, change_month_holidays_path(:date => date), :title => date, :class => 'change-month')
  end

  def link_to_count(count, link_text, singular, path)
    if count > 0
      "#{count} " + link_to("#{link_text} #{count == 1 ? singular : singular.pluralize}", path)
    end
  end

  def replace_day(date, day)
    date.beginning_of_month + day.days - 1
  end

  def date_id(date)
    date.strftime('%d%m%Y')
  end
end
