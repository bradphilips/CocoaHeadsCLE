class UserSessionController < ApplicationController

  respond_to :xml, :json
  #Filters
  before_filter :require_no_user, :only => [:create]
  before_filter :require_user, :only => [:destroy]

  def create
    @current_user_session = UserSession.new(params[:user])
    @current_user_session.remember_me = true unless @current_user_session == nil

    if @current_user_session.save
      if @current_user_session.user && @current_user_session.user.facebook_uid != nil
        @current_user_session.destroy
        respond_with({ :status => "ERROR", :message => "User is linked with facebook.  Login blocked." },
          :status => 401, :location => nil)
        return
      end

      respond_with @current_user_session.user, :except => User.ignored_attributes
    else
      respond_with({ :status => "ERROR", :message => "Username or password incorrect." }, :status => 401, :location => nil)
    end
  end

  def destroy
    if current_user_session.destroy
      respond_with({ :status => "SUCCESS", :message => "You are sucessfully logged out." }, :status => 200, :location => nil)
    else
      respond_with({ :status => "ERROR", :message => "Could not logout." }, :status => 500, :location => nil)
    end
  end

end