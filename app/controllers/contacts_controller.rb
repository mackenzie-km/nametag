class ContactsController < ApplicationController
# before actions - check logged in, check access resource, set admin level for forms
  before_action :redirect_if_no_login
  skip_before_action :redirect_if_no_login, only: [:welcome, :welcome_create, :international_connect, :international_connect_create]
  before_action :access_contact, only: [:show, :edit, :update, :destroy]
  before_action :user_admin_level, only: [:new, :edit, :create, :index]

# decision tree for different kinds of params and secure sql
  def index
    #binding.pry
    @contact = Contact.new
    @contacts = nil

    if !!params[:contact] && !!params[:contact][:name]
      @contacts = Contact.where(name: params[:contact][:name], admin_level: user_admin_level)
    elsif !!params[:contact] && !!params[:contact][:email]
      user = User.find_by(email: params[:contact][:email], admin_level: user_admin_level)
      @contacts = user.contacts if !!user
    elsif !!params[:unclaimed]
      @contacts = Contact.where(user_id: 22)
    elsif !!params[:recently_updated]
      @contacts = Contact.where("updated_at >= ? AND admin_level = ?", Date.today - 1.month, user_admin_level).order(updated_at: :desc)
    elsif params[:event_id]
      event = Event.where("id = ? AND admin_level = ?", params[:event_id], user_admin_level)
      @contacts = event.contacts.order(updated_at: :desc)
    elsif !!params[:all]
      @contacts = Contact.same_level(user_admin_level)
    end
    # render as json or html
    respond_to do |format|
      format.html { render :index }
      format.json { render json: @contacts, status: 200}
    end
  end

  def new
    @event_id = params[:event_id]
    @contact = Contact.new
  end

# creates contact while associating contact with applicable events and user admin level
  def create
    @contact = Contact.new(contact_params.except(:user_id, :event_id))
    @contact.admin_level=(User.find(session[:user_id]))
    @contact.set_event(contact_params[:event_id], user_admin_level)
    @user = User.find_by(id: contact_params[:user_id])
    @contact.user = @user
    @event = Event.find_by(id: contact_params[:event_id])
    if @contact.save then nested_contact_redirect(@event, @contact) else render :new end
  end

  def show
    @events = @contact.events
    respond_to do |format|
      format.html { render :show }
      format.json { render json: @contact, status: 200}
    end
  end

  def edit
  end

  def update
    @user = User.find_by(id: contact_params[:user_id])
    @contact.user = @user
    @contact.update(contact_params.except(:user_id, :event_id))
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

  def welcome
    @contact = Contact.new
    render template: 'contacts/welcome', layout: false
  end

  def welcome_create
    @contact = Contact.new(contact_params)
    @user = User.find(22)
    @contact.user = @user
    @contact.admin_level=(@user)
    @event = Event.find_or_create_by(name: "Large Group", admin_level: 1, created_at: Date.current, date: Date.current)
    if @contact.save
      @contact.event_id = @event.id.to_s
    end
  end

  def international_connect
    @contact = Contact.new
    render template: 'contacts/international_connect', layout: false
  end

  def international_connect_create
    @contact = Contact.new(contact_params)
    @user = User.find(22)
    @contact.user = @user
    @contact.admin_level=(@user)
    @event = Event.find_or_create_by(name: "International Connect", admin_level: 1, created_at: Date.current, date: Date.current)
    if @contact.save
      @contact.events << @event
    end
  end

  private
  # allowed contact parameters
  def contact_params
    params.require(:contact).permit(:name, :email, :gender, :phone_number, :school_status, :last_day, :messenger_id, :major, :country, :birthday, :unsubscribed, :newsletters, :source, :event_id, :user_id)
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
