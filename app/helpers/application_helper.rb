module ApplicationHelper
  def set_title(title)
    @title = title
  end

  def print_flash(flash, flash_type, title = nil)
    if flash
      hide_link = link_to_function('Hide') do |page| page["#{flash_type}-flash"].visual_effect :fade end
      title_p = "<h5>#{title}</h5>" if title
      result = "<div id=\"#{flash_type}-flash\">#{title_p}<p>"

      messages = []
      if flash.class == ActiveRecord::Errors
        flash.each {|attr, msg| messages << "<span class=\"error-msg\">#{h(msg)}</span>" if !msg.blank?}
      elsif flash.class == Array
        flash.each {|msg| messages << "<span class=\"error-msg\">#{h(msg)}</span>" if !msg.blank?}
      else
        result << "<span class=\"error-msg\">#{h(flash)}</span>"
      end

      result << messages.join('<br />')
      result << "</p><p>#{hide_link}</p></div>"
    end
  end

  def menu_extra(activemenuitem)
    css = "<style type=\"text/css\" media=\"screen\">\n"
    css << "<!--\n"
    css << "div#menu ul li a##{activemenuitem}, div#menu ul li a##{activemenuitem}:hover {\n"
    css << "  color: #0f0;\n"
    css << "}\n"
    css << "-->\n"
    css << "</style>\n"
  end
end
