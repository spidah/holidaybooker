ActionController::Routing::Routes.draw do |map|
  map.resource          :session
  map.resources         :holidays,                :collection => { :change_month => :get, :confirmed => :get, :unconfirmed => :get, :taken => :get }
  map.resources         :departments,             :member => { :change_month => :get }

  map.namespace(:admin) do |admin|
    admin.resources :users,                       :controller => 'admin_users',         :member => { :change_head => :put, :change_admin => :put }
    admin.resources :departments,                 :controller => 'admin_departments'
  end

  map.home              '',                       :controller => 'application',         :action => 'home'
  map.login             '/login',                 :controller => 'sessions',            :action => 'new'
  map.logout            '/logout',                :controller => 'sessions',            :action => 'destroy'
  map.signup            '/signup',                :controller => 'sessions',            :action => 'signup'

  map.connect           '*path',                  :controller => 'holidays',            :action => 'index'
end
