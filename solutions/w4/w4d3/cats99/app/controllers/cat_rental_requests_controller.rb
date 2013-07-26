class CatRentalRequestsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :authorize_user!, only: [:update]

  def new
    @cat = Cat.find(params[:cat_id])
    @request = CatRentalRequest.new
  end

  def create
    @cat = Cat.find(params[:cat_id])
    @request = @cat.cat_rental_requests.build(params[:cat_rental_request])
    if @request.save
      redirect_to @cat
    else
      render :new
    end
  end

  def update
    @cat = Cat.find(params[:cat_id])
    req = CatRentalRequest.find(params[:id])
    if params[:cat_rental_request][:status] && 
      params[:cat_rental_request][:status] == "approved"
        req.approve
    else
      req.update_attributes(params[:cat_rental_request])
    end
    redirect_to @cat
  end

  def authorize_user!
    cat = Cat.find(params[:cat_id])
    unless current_user == cat.user
      flash[:error] = "Only the owner of the cat can do this."
      redirect_to cat
    end
  end
end
