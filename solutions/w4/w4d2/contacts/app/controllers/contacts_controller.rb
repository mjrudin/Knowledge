class ContactsController < ApplicationController
  before_filter :authenticate_user!

  def index
    user = User.find(params[:user_id])
    render :json => user.contacts
  end

  def create
    user = User.find(params[:user_id])
    contact = user.contacts.create(params[:contact])
    render :json => contact
  end

  def show
    contact = Contact.find(params[:id])
    render :json => contact
  end

  def update
    contact = Contact.find(params[:id])
    if contact.update_attributes(params[:contact])
      render :json => contact
    else
      render :json => { status: "oops" }, status: 422
    end
  end

end
