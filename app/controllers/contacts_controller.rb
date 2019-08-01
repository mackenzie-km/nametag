class ContactsController < ApplicationController

# before actions - check logged in, check access resource, set admin level for forms
  before_action :redirect_if_no_login
  before_action :access_contact, only: [:show, :edit, :update, :destroy]
  before_action :user_admin_level, only: [:new, :edit]

# FIX - write a scope for only your own contacts & button for all contacts
  def index
    if params[:event_id]
      @event = Event.find(params[:event_id])
      @contacts = @event.contacts
    else
      @contacts = Contact.access(current_user.admin_level)
    end
  end

  def new
    @event_id = params[:event_id]
    @contact = Contact.new
  end

# creates contact while associating contact with applicable events and user admin level
  def create
    @contact = Contact.new(contact_params)
    @contact.admin_level=(User.find(session[:user_id]))
    @event = Event.find_by(id: params[:contact][:event_id])
    if (!!@event && has_access?(@event.admin_level)) then @contact.events << @event end
    if @contact.save then nested_contact_redirect(@event, @contact) else render :new end
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
  # allowed contact parameters
  def contact_params
    params.require(:contact).permit(:name, :email, :gender, :user_id, :phone_number, :school_status, :messenger_company, :messenger_id, :major, :country, :birthday)
  end

# finds contact
  def find_contact
    @contact = Contact.find(params[:id])
  end

# runs find_contact & returns T or F with error depending on user access level
  def access_contact
    find_contact
    if !has_access?(@contact.admin_level)
      flash[:notice] = "You cannot edit/view this contact."
      redirect_to contacts_path
    end
  end

# chooses redirect based on whether contact is nested or not 
  def nested_contact_redirect(event, contact)
    if !!event then redirect_to event_contacts_path(event) else redirect_to contact_path(contact) end
  end
end
