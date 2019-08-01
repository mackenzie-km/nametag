class ContactsController < ApplicationController

# before actions - check logged in, check access resource, set admin level for forms
  before_action :redirect_if_no_login
  before_action :access_contact, only: [:show, :edit, :update, :destroy]
  before_action :user_admin_level, only: [:new, :edit]

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

  def create
    @contact = Contact.new(contact_params)
    @contact.admin_level=(User.find(session[:user_id]))
    if !!Event.exists?(id: params[:contact][:event_id]) then @contact.events << Event.find_by(id: params[:contact][:event_id].to_i) end
    if @contact.save then redirect_to contact_path(@contact) else render :new end
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
end
