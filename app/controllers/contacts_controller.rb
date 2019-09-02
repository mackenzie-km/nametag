class ContactsController < ApplicationController

# before actions - check logged in, check access resource, set admin level for forms
  before_action :redirect_if_no_login
  before_action :access_contact, only: [:show, :edit, :update, :destroy]
  before_action :user_admin_level, only: [:new, :edit]

# default: shows your contacts. otherwise, if nested => event contacts. if all selected => all contacts.
  def index
    if params[:event_id]
      @event = Event.find(params[:event_id])
      @contacts = @event.contacts.order(updated_at: :desc)
    elsif params[:display_all]
      @contacts = Contact.same_level(current_user.admin_level).order(updated_at: :desc)
    else
      @contacts = Contact.yours(current_user.id).order(name: :asc)
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
    @event = Event.find_by(id: contact_params[:event_id])
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

  def newsletter
    @contacts = Contact.newsletter_pending(current_user.admin_level)
  end

  def newsletter_update
    if params[:newsletters]
      @contacts = Contact.newsletter_pending(current_user.admin_level)
      Contact.update_newsletter_status(@contacts)
    end
    redirect_to "/newsletter"
  end

  def unsubscribed
    @contacts = Contact.unsubscribed(current_user.admin_level)
  end

  private
  # allowed contact parameters
  def contact_params
    params.require(:contact).permit(:name, :email, :gender, :user_id, :phone_number, :school_status, :last_day, :messenger_id, :major, :country, :birthday, :unsubscribed, :newsletters, :event_id)
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
    if !!event then redirect_to event_path(event) else redirect_to contact_path(contact) end
  end
end
