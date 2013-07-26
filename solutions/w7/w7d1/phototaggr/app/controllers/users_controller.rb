class UsersController < ApplicationController
  
  def create
    @user = User.new(params[:user])

    if @user.save
      redirect_to @user
    else
      respond_to do |format|
        format.json { render :json => @user }
        format.html { render :show }
      end
    end
  end

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
    respond_to do |format|
      format.json { render :json => @user }
      format.html { render :show }
    end
  end
end