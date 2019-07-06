class EventsController < ApplicationController

  before_action :redirect_if_no_login
  before_action :access_event, only: [:show, :edit, :update, :destroy]

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
  end

  def create
    @event = Event.new(event_params)
    @event.contacts = Contact.add_contacts(params[:event][:contact_ids], @event)
    @event.admin_level = current_user.admin_level
    if @event.save then redirect_to event_path(@event) else render :new end
  end

  def show
  end

  def edit
  end

  def update
    @event.update(event_params)
    @event.contacts = Contact.add_contacts(params[:event][:contact_ids], @event)
    if @event.save then redirect_to event_path(@event) else render :edit end
  end

  def destroy
    @event.delete
    redirect_to events_path
  end

  private
  def event_params
    params.require(:event).permit(:name, :date, :contact_ids)
  end

  def find_event
    @event = Event.find(params[:id])
  end

  def access_event
    find_event
    if !has_access?(@event.admin_level)
      flash[:message] = "You cannot edit/view this event."
      redirect_to events_path
    end
  end
end
