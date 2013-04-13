class ApplicationController < ActionController::Base

  include ActionController::MimeResponds
  respond_to :xml, :json
  responders :json

  protect_from_forgery
  helper_method :current_user

private

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
    return @current_user_session
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.user
    return @current_user
  end

  def require_user
    unless current_user
      respond_with({ :status => "ERROR", :message => "Invalid access.  User is not logged in." }, :status => 401, :location => nil)
      return false
    end
  end

  def require_no_user
    if current_user
      respond_with({ :status => "ERROR", :message => "Invalid access.  User is not logged out." }, :status => 400, :location => nil)
      return false
    end
  end

end
