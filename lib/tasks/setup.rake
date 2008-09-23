require 'highline/import'

namespace :db do
  desc "Setup the application for first use."
  task :setup => ['db:setup:setup']

  namespace :setup do
    desc "Setup the application for first use."
    task :setup => :environment do
      do_admin = User.count == 0

      if do_admin
        username = ask('admin username: ')
        password = '1'
        passconf = '2'
        while password != passconf do
          password = ask('admin password: ') { |p| p.echo = '*' }
          passconf = ask('retype password: ') { |p| p.echo = '*' }
        end
      end

      Rake::Task["db:setup:roles"].invoke

      if do_admin
        puts "--- Creating admin user"
        admin_user = create_user(username, password, passconf)
        puts "--- #{username} created"
        admin_role = find_role('Admin')
        admin_user.roles.clear
        admin_user.roles << admin_role
      end

      answer = agree('Add a user? ', true)
      while answer do
        username = ask('username: ')
        password = '1'
        passconf = '2'
        while password != passconf do
          password = ask('password: ') { |p| p.echo = '*' }
          passconf = ask('retype password: ') { |p| p.echo = '*' }
        end
        firstname = ask('firstname: ')
        surname = ask('surrname: ')
        create_user(username, password, passconf, firstname, surname)
        puts "--- #{username} created"

        answer = agree('Add another user? ', true)
      end
    end

    desc "Load initial roles and rights into the current environment's database."
    task :roles => :environment do
      puts "--- Adding roles and rights (if any)"

      create_role('Admin')

      standard_user_role = create_role('Standard user')

      create_right(standard_user_role, 'Users index page', 'users', 'index')
      create_right(standard_user_role, 'Holidays index page', 'holidays', 'index')
      create_right(standard_user_role, 'New holiday page', 'holidays', 'new')
      create_right(standard_user_role, 'Create holiday page', 'holidays', 'create')
      create_right(standard_user_role, 'Destroy holiday page', 'holidays', 'destroy')
      create_right(standard_user_role, 'Edit holiday page', 'holidays', 'edit')
      create_right(standard_user_role, 'Update holiday page', 'holidays', 'update')
      create_right(standard_user_role, 'Change holiday calendar month', 'holidays', 'change_month')
      create_right(standard_user_role, 'View confirmed holidays', 'holidays', 'confirmed')
      create_right(standard_user_role, 'View unconfirmed holidays', 'holidays', 'unconfirmed')

      puts "--- Finished adding roles and rights"
    end
  end
end

private
  def create_user(username, password, password_confirmation, firstname = nil, surname = nil)
    u = User.new
    u.username = username
    u.password = password
    u.password_confirmation = password_confirmation
    u.firstname = firstname
    u.surname = surname
    u.save
    u
  end

  def find_role(name)
    Role.find(:first, :conditions => {:name => name})
  end

  def create_role(name)
    if !(role = find_role(name))
      puts "Creating role: #{name}"
      Role.create(:name => name)
    else
      role
    end
  end

  def create_right(role, name, controller, action)
    if !Right.find(:first, :conditions => {:name => name, :controller => controller, :action => action})
      puts "Creating right: #{name}"
      right = Right.create(:name => name, :controller => controller, :action => action)
      role.rights << right
    end
  end
