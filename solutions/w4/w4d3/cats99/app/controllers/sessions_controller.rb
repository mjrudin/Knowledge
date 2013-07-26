class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by_username(params[:username])
    if user && user.password == params[:password]
      login(user)
      redirect_to cats_path
    else
      flash.now[:error] = "Invalid login. Please try again."
      render :new
    end
  end

  def destroy
    logout
    redirect_to :back
  end
end
