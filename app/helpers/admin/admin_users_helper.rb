module Admin::AdminUsersHelper
  def sort_link(title, action = nil)
    action = title.downcase if action == nil
    direction = action == params[:sort] ? (params[:dir] == 'down' ? nil : 'down') : nil
    link_to(title, admin_users_path(:sort => action, :dir => direction), :class => 'sort-header')
  end

  def department_link(user)
    content_tag(:div, :class => 'department', :title => change_department_admin_user_path(user)) do
      user.department ? user.department.name : ''
    end
  end

  def head_link(user)
    if user.id == @current_user.id
      image_tag(user.head ? '/images/tick.gif' : '/images/cross.gif')
    else
      link_to(image_tag(user.head ? '/images/tick.gif' : '/images/cross.gif'), change_head_admin_user_path(user), :class => 'change-head')
    end
  end

  def admin_link(user)
    if user.id == @current_user.id
      image_tag('/images/tick.gif')
    else
      link_to(image_tag(user.admin ? '/images/tick.gif' : '/images/cross.gif'), change_admin_admin_user_path(user), :class => 'change-admin')
    end
  end

  def print_roles(roles)
    roles.collect(&:name).join(', ')
  end
end
