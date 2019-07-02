class ContactsController < ApplicationController

  before_action :redirect_if_no_login
  before_action :find_contact, only: [:show, :edit, :update, :destroy]

  def index
    if params[:event_id]
      @event = Event.find(params[:event_id])
      @contacts = @event.contacts
    else
      @contacts = Contact.all
    end
  end

  def new
    @contact = Contact.new
  end

  def create
    contact = Contact.new(contact_params)
    contact.admin_level=(User.find(session[:user_id]))
    if contact.save then redirect_to contact_path(contact) else render :new end
  end

  def show
  end

  def edit
  end

  def update
    @contact.update(contact_params)
    if @contact.save then redirect_to contact_path(@contact) else render :edit end
  end

  def destroy
    @contact.delete
    redirect_to contacts_path
  end

  private
  def contact_params
    params.require(:contact).permit(:name, :email, :gender, :user_id, :phone_number, :school_status, :messenger_company, :messenger_id, :major, :country, :birthday)
  end

  def find_contact
    @contact = Contact.find(params[:id])
  end
end
