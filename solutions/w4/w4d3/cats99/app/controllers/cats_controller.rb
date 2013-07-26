class CatsController < ApplicationController
  before_filter :authenticate_user!, except: [:index, :show]
  before_filter :authorize_user!, only: [:edit, :update, :destroy]

  def index
    @cats = Cat.all
  end

  def show
    @cat = Cat.find(params[:id])
  end

  def new
    @cat = Cat.new
  end

  def create
    @cat = current_user.cats.build(params[:cat])
    if @cat.save
      redirect_to @cat
    else
      render :new
    end
  end

  def edit
    @cat = Cat.find(params[:id])
  end

  def update
    @cat = Cat.find(params[:id])
    if @cat.update_attributes(params[:cat])
      redirect_to @cat
    else
      render :edit
    end
  end

  def destroy
    @cat = Cat.find(params[:id])
    @cat.destroy
    redirect_to cats_path
  end

  private

  def authorize_user!
    cat = Cat.find(params[:id])
    unless current_user == cat.user
      flash[:error] = "Only the owner of the cat can do this."
      redirect_to cat
    end
  end
end
