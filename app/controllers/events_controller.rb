class EventsController < ApplicationController

  before_action :redirect_if_no_login
  before_action :access_event, only: [:show, :edit, :update, :destroy]
  before_action :find_user, only: [:create, :update]

  def index
    if params[:contact_id]
      @contact = Contact.find(params[:contact_id])
      @events = @contact.events
    else
      @events = Event.all.access(current_user.admin_level)
    end
  end

  def new
    @event = Event.new
    @admin = current_user.admin_level
  end

  def create
    date = Event.collect_date(event_params)
    @event = Event.new(name: event_params[:name], date: date)
    @event.save
    Contact.add_contacts(event_params, @event, @user)
    @event.update_guests(event_params, @event)
    @event.admin_level = current_user.admin_level
    if @event.save then redirect_to event_path(@event) else render :new end
  end

  def show
  end

  def edit
    @admin = current_user.admin_level
  end

  def update
    @event.update(name: event_params[:name], date: Event.collect_date(event_params))
    Contact.add_contacts(event_params, @event, @user)
    @event.update_guests(event_params, @event)
    if @event.save then redirect_to event_path(@event) else render :edit end
  end

  def destroy
    @event.delete
    redirect_to events_path
  end

  private
  def event_params
    params.require(:event).permit(:name, :date, :guests => {}, contact_ids:[])
  end

  def find_event
    @event = Event.find(params[:id])
  end

  def access_event
    find_event
    if !has_access?(@event.admin_level)
      flash.now[:alert] = "You cannot edit/view this event."
      redirect_to events_path
    end
  end

  def find_user
    @user = current_user
  end
end
