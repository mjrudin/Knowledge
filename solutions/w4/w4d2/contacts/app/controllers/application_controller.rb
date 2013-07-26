class ApplicationController < ActionController::Base
  protect_from_forgery

  def current_user
    @current_user ||= (params[:token] && User.find_by_token(params[:token]))
  end

  def logged_in?
    !!current_user
  end

  def authenticate_user!
    unless logged_in?
      render :json => { status: "unauthorized" }, status: 403
    end
  end
end
