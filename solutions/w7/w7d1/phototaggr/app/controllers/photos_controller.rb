class PhotosController < ApplicationController
  before_filter :authenticate_user! 

  def index
    respond_to do |format|
      format.html { render :index }
      format.json { render :json => current_user.owned_photos }
    end
  end
  
  def create
    @photo = Photo.new(params[:photo])
    @photo.owner = current_user
    
    if @photo.save
      render :json => @photo
    else #see note on friendships#create
      render :json => @photo.as_json(:methods => :errors), :status => :unprocessable_entity
    end
  end
  
  def show
    @photo = Photo.find(params[:id])
    render :json => @photo
  end
  
  def update
    @photo = Photo.find(params[:id])
    
    if @photo.update_attributes(params[:photo])
      render :json => @photo
    else
      render :json => @photo.as_json(:methods => :errors), :status => :unprocessable_entity
    end  
  end
  
  def destroy
    @photo = Photo.find(params[:id])
    @photo.destroy
    render :json => {status: "ok"}
  end

end
