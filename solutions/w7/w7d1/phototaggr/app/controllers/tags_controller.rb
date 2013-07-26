class TagsController < ApplicationController
  def index
    @tags = Tag.find_by_photo_id(params[:photo_id])
  end
  
  def create
    @tag = Tag.new(:user_id => params[:user_id], 
                   :photo => params[:photo_id])
    if @tag.save
      render :json => @tag
    else
      render :json => @tag.as_json(:methods => :errors), :status => :unprocessable_entity
    end  
  end

  
  def destroy
    @tag = Tag.find(:params[:id])
    @tag.destroy
  end
end