class ApplicationController < ActionController::Base

  include ActionController::MimeResponds
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
      return false
    end
  end

  def require_no_user
    if current_user
      return false
    end
  end

end
