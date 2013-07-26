class ApplicationController < ActionController::Base
  include SessionsHelper
  protect_from_forgery

  def authenticate_user!
    redirect_to new_session_path unless logged_in?
  end
end
