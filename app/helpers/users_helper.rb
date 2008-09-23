module UsersHelper
  def link_to_count(count, link_text, singular, path)
    if count > 0
      "#{count} " + link_to("#{link_text} #{count == 1 ? singular : singular.pluralize}", path)
    end
  end
end
