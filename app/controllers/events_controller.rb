class EventsController < ApplicationController

  before_action :redirect_if_no_login
  before_action :find_event, only: [:show, :edit, :update, :destroy]

  def index
    if params[:contact_id]
      @contact = Contact.find(params[:contact_id])
      @events = @contact.events
    else
      @events = Event.all
    end
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)
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
end
