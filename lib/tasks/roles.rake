namespace :db do
  desc "Loads initial roles and rights into the current environment's database."
  task :roles => ['db:roles:load']

  namespace :roles do
    desc "Load initial roles and rights into the current environment's database."
    task :load => :environment do
      ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)

      standard_user_role = create_role('Standard user')

      create_right(standard_user_role, 'Users index page', 'users', 'index')
      create_right(standard_user_role, 'Holidays index page', 'holidays', 'index')
      create_right(standard_user_role, 'New holiday page', 'holidays', 'new')
      create_right(standard_user_role, 'Create holiday page', 'holidays', 'create')
      create_right(standard_user_role, 'Destroy holiday page', 'holidays', 'destroy')
      create_right(standard_user_role, 'Edit holiday page', 'holidays', 'edit')
      create_right(standard_user_role, 'Update holiday page', 'holidays', 'update')

      standard_user_role.save
    end
  end
end

private
  def create_role(name)
    if !(role = Role.find(:first, :conditions => {:name => name}))
      puts "Creating role: #{name}"
      Role.create(name)
    else
      puts "Role exists: #{name}"
      role
    end
  end

  def create_right(role, name, controller, action)
    if !Right.find(:first, :conditions => {:name => name, :controller => controller, :action => action})
      puts "Creating right: #{name}"
      right = Right.create(:name => name, :controller => controller, :action => action)
      role.rights << right
    else
      puts "Right exists: #{name}"
    end
  end
