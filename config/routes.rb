ActionController::Routing::Routes.draw do |map|
  map.resource          :session
  map.resource          :user
  map.resources         :holidays

  map.home              '',                       :controller => 'users',               :action => 'index'
  map.login             '/login',                 :controller => 'sessions',            :action => 'new'
  map.logout            '/logout',                :controller => 'sessions',            :action => 'destroy'
  map.signup            '/signup',                :controller => 'sessions',            :action => 'signup'

  map.connect           '',                       :controller => 'users',               :action => 'index'
  map.connect           '*path',                  :controller => 'users',               :action => 'index'
end
