class UsersController < ApplicationController
  before_filter :authenticate_user!

  def show
    user = User.find(params[:id])
    render :json => user
  end

  def create
    user = User.new(params[:user])
    if user.save
      render :json => user
    else
      render :json => user.errors, status: 422
    end
  end

  def update
    user = User.find(params[:id])
    if user.update_attributes(params[:user])
      render :json => user
    else
      render :json => user.errors, status: 422
    end
  end

  def destroy
    user = User.find(params[:id])
    user.destroy
    render :json => { status: "ok" }
  end

end
