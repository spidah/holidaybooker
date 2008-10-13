module RoleSystem
  def self.included(klass)
    klass.send :class_inheritable_array, :needed_roles
    klass.send :extend, RoleSystemClassMethods
    klass.send :include, RoleSystemInstanceMethods
    klass.send :needed_roles=, []
  end

  module RoleSystemClassMethods
    def needs_role(role, options = {})
      unless @before_filter_declared ||= false
        @before_filter_declared = true
        before_filter :check_login
        before_filter :check_roles
      end

      role = role.to_s
      actions = options[:actions] ? options[:actions] : :*
      actions = [actions] unless Array === actions
      self.needed_roles ||= []
      self.needed_roles << {:role => role, :actions => actions}
    end

    def user_can_access?(user, action)
      matched = self.needed_roles.select { |required| required[:actions].include?(action.to_sym) || required[:actions].include?(:*) }
      matched.each { |role| return true if user.has_role?(role[:role]) }
      false
    end
  end

  module RoleSystemInstanceMethods
    def check_roles
      return true if self.class.user_can_access?(current_user, action_name)

      redirect_to(home_path)
    end
  end
end
