class SessionsController < ApplicationController
  before_filter :authenticate_user!, only: [:destroy]

  def create
    user_attributes = params[:user]
    @user = login_user(params[:user][:username],
                       params[:user][:password])

    if @user
      redirect_to photos_path
    else
      @user = User.new(params[:user])
      render :new
    end
  end

  def new
    @user = User.new
  end

  def destroy
    current_user.session_token = nil
    current_user.save!
    session[:session_token] = nil
    redirect_to :back
  end
end
