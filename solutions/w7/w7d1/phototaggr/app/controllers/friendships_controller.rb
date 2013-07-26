class FriendshipsController < ApplicationController
  def show
    @friendships = Friendship.where(:friender => params[:user_id]) 
  end
  
  def followers
    @followers = Friendship.where(:friendee => params[:user_id])
  end
  
  def create
    @friendship = Friendship.new(:friendee => params[:user_id], 
                                 :friender => current_user.id)
    if @friendship.save
      render :json => @friendship
    else
      # So after we fail to save the model, we want to make sure JS can catch the errors.
      # So we will send the errors, and set the status code to 422 (unprocessable entity).
      # to include the result of some method calls on the model, we use the :methods
      # option to grab the errors before rendering.
      render :json => @friendship.as_json(:methods => :errors), :status => :unprocessable_entity
    end
  end
  
  def destroy
    @friendship = Friendship.where(:friendee => params[:user_id], 
                                     :friender => current_user.id)
    @friendship.destroy 
  end
end
