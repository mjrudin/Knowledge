class SessionsController < ApplicationController
  def create
    user = User.find_by_email(params[:email])
    if user
      user.token = generate_unique_token
      user.save!
      render :json => { token: user.token }
    else
      render :json => { status: "unauthorized" }, status: 403
    end
  end

  def destroy
    if current_user
      current_user.token = nil
      current_user.save!
    end
    render :json => { status: "ok" }
  end

  private

  def generate_unique_token
    token = SecureRandom.urlsafe_base64(32)
    while User.find_by_token(token) 
      token = SecureRandom.urlsafe_base64(32) 
    end
    token
  end
end
