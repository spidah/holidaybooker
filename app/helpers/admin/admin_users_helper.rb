module Admin::AdminUsersHelper
  def sort_link(title, action = nil)
    action = title.downcase if action == nil
    direction = action == params[:sort] ? (params[:dir] == 'down' ? nil : 'down') : nil
    link_to(title, admin_users_path(:sort => action, :dir => direction), :class => 'sort-header')
  end

  def head_image(head)
    image_tag(head ? '/images/tick.gif' : '/images/cross.gif')
  end
end
