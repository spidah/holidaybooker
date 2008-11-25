class Department < ActiveRecord::Base
  has_many :users
  has_many :heads, :class_name => 'User', :finder_sql => %q(
    SELECT * FROM users u, roles_users ru 
    WHERE u.department_id = #{id} AND ru.user_id = u.id AND ru.role_id = 
    (SELECT id FROM roles WHERE name = 'head')
  )

  def self.pagination(page, dir = 'ASC')
    paginate(:page => page, :per_page => 50, :order => "name #{dir}")
  end
end
