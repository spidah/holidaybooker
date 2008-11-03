require 'highline/import'

namespace :db do
  desc "Setup the application for first use."
  task :setup => ['db:setup:setup']

  namespace :setup do
    desc "Setup the application for first use."
    task :setup => :environment do
      do_admin = User.count == 0

      if do_admin
        username = get_answer('admin username: ')
        password = '1'
        passconf = '2'
        while password != passconf do
          password = get_answer('admin password: ', true)
          passconf = get_answer('retype password: ', true, true)
        end
      end

      create_roles(['admin', 'user', 'head'])

      if do_admin
        puts "--- Creating admin user"
        admin_user = create_user(username, password, passconf)
        puts "--- #{username} created"
        admin_role = Role.get('admin')
        admin_user.roles.clear
        admin_user.roles << admin_role
      end

      Rake::Task["db:setup:add_user"].invoke if agree('Add a user? ', true)
    end

    desc "Adds users to the current environment's database."
    task :add_user => :environment do
      answer = true
      while answer do
        username = get_answer('username: ')
        password = '1'
        passconf = '2'
        while password != passconf do
          password = get_answer('password: ', true)
          passconf = get_answer('retype password: ', true, true)
        end
        firstname = get_answer('firstname: ')
        surname = get_answer('surname: ')
        create_user(username, password, passconf, firstname, surname)
        puts "--- #{username} created"

        answer = agree('Add another user? ', true)
      end
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

  def create_roles(roles)
    puts "--- Adding roles"
    roles.each { |role|
      Role.create(:name => role)
    }
    puts "--- Finished adding roles"
  end

  def get_answer(question, password = false, allow_blank = false)
    answer = ask(question) { |p| p.echo = '*' if password }
    while !allow_blank && answer.blank? do
      answer = ask(question) { |p| p.echo = '*' if password }
    end
    answer
  end
