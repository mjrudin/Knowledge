require "BCrypt"

module SessionsHelper

  def authenticate_user! 
    unless current_user
      redirect_to new_session_path
    end
  end

  def current_user
    return nil unless session[:session_token]
    User.find_by_session_token(session[:session_token])
  end

  def login_user(username, password)
    user = User.find_by_username(username)

    if user && BCrypt::Password.new(user.password_digest) == password

      user.session_token = SecureRandom::urlsafe_base64(32)
      user.save!
      session[:session_token] = user.session_token

      return user
    end

    nil
  end
end
