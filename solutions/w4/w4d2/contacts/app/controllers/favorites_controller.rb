class FavoritesController < ApplicationController
  before_filter :authenticate_user!

  def index
    user = User.find(params[:user_id])
    render :json => user.favorites
  end

  def create
    fav = Favorite.find_by_user_and_contact_id(
      params[:user_id], params[:contact_id])
    if fav.count == 0
      Favorite.create!({
        user_id: params[:user_id],
        contact_id: params[:contact_id]
      })
    end
    render :json => { status: "ok" }
  end

  def destroy
    fav = Favorite.find_by_user_and_contact_id(
      params[:user_id], params[:contact_id])
    fav.destroy_all
    render :json => { status: "ok" }
  end
  
end
