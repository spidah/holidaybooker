module Admin::AdminUsersHelper
  def sort_link(title, action = nil)
    action = title.downcase if action == nil
    direction = action == params[:sort] ? (params[:dir] == 'down' ? nil : 'down') : nil
    link_to(title, admin_users_path(:sort => action, :dir => direction), :class => 'sort-header')
  end

  def head_link(user)
    link_to(image_tag(user.head ? '/images/tick.gif' : '/images/cross.gif'), change_head_admin_user_path(user), :class => 'change-head')
  end

  def admin_link(user, admin_role)
    admin = true if user.roles.find(admin_role.id) rescue false
    link_to(image_tag(admin ? '/images/tick.gif' : '/images/cross.gif'), change_admin_admin_user_path(user), :class => 'change-admin')
  end

  def print_roles(roles)
    roles.collect(&:name).join(', ')
  end
end
