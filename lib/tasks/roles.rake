namespace :db do
  desc "Loads initial roles and rights into the current environment's database."
  task :roles => ['db:roles:load']

  namespace :roles do
    desc "Load initial roles and rights into the current environment's database."
    task :load => :environment do
      ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)

      standard_user_role = Role.create(:name => 'Standard user')
      right = Right.create(:name => 'Users index page', :controller => 'users', :action => 'index')

      standard_user_role.rights << right
      standard_user_role.save
    end
  end
end
