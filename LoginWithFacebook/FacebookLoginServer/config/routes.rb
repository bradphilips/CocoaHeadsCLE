FacebookLoginServer::Application.routes.draw do

  scope 'api/v1' do
    resource :user, :except => [:edit, :new], :controller => :user do
      post 'facebook/login', :on => :member, :action => :facebook_login
      resource  :session, :only => [:create, :destroy], :controller => :user_session
    end
  end

end
