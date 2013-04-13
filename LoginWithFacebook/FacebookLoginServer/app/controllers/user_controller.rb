class UserController < ApplicationController

  #Filters
  before_filter :require_no_user, :only => [:create]
  before_filter :require_user, :only => [:show, :destroy, :update]

  def show
    respond_with current_user, :except => User.ignored_attributes
  end

  def create
    # Check user is already registered.
    if User.find_by_email(params[:user][:email])
      respond_with({ :status => "ERROR", :message => "Your email is already registered.  Please login." }, :status => 400, :location => nil)
    else
      user = save_user(params[:user])
      if user[:status] == nil
        respond_with user, :except => User.ignored_attributes
      else
        respond_with(user, :status => 500, :location => nil)
      end
    end
  end

  def update
    if current_user.update_attributes(params[:user])
      respond_with current_user, :except => User.ignored_attributes
    else
      respond_with({ :status => "ERROR", :message => "There was an error updating the user." }, :status => 500, :location => nil)
    end
  end

  def destroy
    if current_user.destroy
      respond_with({ :status => "SUCESS", :message => "User was deleted successfully" }, :status => 200, :location => nil)
    else
      respond_with({ :status => "ERROR", :message => "User could not be deleted" }, :status => 500, :location => nil)
    end
  end

  def facebook_login
    fb_user = HTTParty.get("https://graph.facebook.com/me/?access_token=#{params[:access_token]}")
    user = User.find_by_facebook_uid(fb_user["id"])
    if user
      @current_user = user
      @current_user_session = UserSession.new(@current_user, true)
      @current_user_session.remember_me = true

      if @current_user_session.save
        respond_with @current_user, :except => User.ignored_attributes
      else
        respond_with({ :status => "ERROR", :message => "There was an error logging into your account." }, :status => 401, :location => nil)
      end
    else
      if User.find_by_email(fb_user["email"])
        respond_with({ :status => "ERROR", :message => "Your email is already registered.  Please login." }, :status => 401, :location => nil)
      else
        # Create a new user with their fb profile
        pwd = Digest::SHA1.hexdigest("#{fb_user["first_name"]}.#{fb_user["last_name"]}")
        user = save_user({
            :email => fb_user["email"],
            :firstname => fb_user["first_name"],
            :facebook_uid => fb_user["id"],
            :password => pwd,
            :password_confirmation => pwd
          })
        if user[:status] == nil
          respond_with user, :except => User.ignored_attributes
        else
          respond_with(user, :status => 500, :location => nil)
        end
      end
    end
  end

  def save_user(params = {})
    @current_user = User.new(params)

    if @current_user.save
      @current_user_session = UserSession.new(params[:user])
      @current_user_session.remember_me = true
      @current_user_session.save

      return @current_user
    end

    return { :status => "ERROR", :message => "There was an error saving the user." }
  end

end