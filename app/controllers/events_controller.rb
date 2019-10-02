class EventsController < ApplicationController

# before - check login, check resource access, load admin level
  before_action :redirect_if_no_login
  before_action :access_event, only: [:show, :edit, :update, :destroy]
  before_action :user_admin_level, only: [:index, :new, :create, :edit]

# events will be filtered based on whether it's nested under a contact or not
  def index
    if params[:contact_id]
      @contact = Contact.find(params[:contact_id])
      @events = @contact.events.order(date: :desc)
    else
      @events = Event.access(@user_admin_level).order(date: :desc)
    end
  end

  def new
    @event = Event.new
    @contacts = Contact.same_level(@user_admin_level).order(name: :asc)
    render :edit
  end

# add date, admin level, and contacts separately from .new method
  def create
    params["date"] = Event.collect_date(event_params) if params[:date]
    @event = Event.new(event_params)
    @event.admin_level = @user_admin_level
    if @event.save
      render json: @event, status: 201
    end
  end

  def show
    respond_to do |format|
      format.html {
        @contacts = @event.contacts
        render :show  }
      format.json { render json: @event, status: 200}
    end
  end

  def edit
    @contacts = Contact.same_level(@user_admin_level).order(name: :asc)
  end

# update contacts & date separately from .update method
  def update
    if !!params[:event][:name]
      params[:event][:date] = Event.collect_date(event_params)
      @event.update(event_params)
    end
    Event.toggle_contact(params)
    @event.save
    render json: @event, status: 201
  end

  def destroy
    @event.delete
    redirect_to events_path
  end

  private
  # permitted event parameters
  def event_params
    params.require(:event).permit(:name, :date, :guest_count, :staff_count, contacts: {}).select { |k, v| !v.nil? }
  end

  # finds events
  def find_event
    @event = Event.find(params[:id])
  end

  # uses find event to see if user has right access permission for event
  def access_event
    find_event
    if !has_access?(@event.try(:admin_level))
      flash.now[:alert] = "You cannot edit/view this event."
      redirect_to events_path
    end
  end

end
