ActionController::Routing::Routes.draw do |map|
  map.resource          :session
  map.resources         :holidays,                :collection => { :change_month => :get, :confirmed => :get, :unconfirmed => :get }

  map.home              '',                       :controller => 'holidays',            :action => 'index'
  map.login             '/login',                 :controller => 'sessions',            :action => 'new'
  map.logout            '/logout',                :controller => 'sessions',            :action => 'destroy'
  map.signup            '/signup',                :controller => 'sessions',            :action => 'signup'

  map.connect           '',                       :controller => 'holidays',            :action => 'index'
  map.connect           '*path',                  :controller => 'holidays',            :action => 'index'
end
