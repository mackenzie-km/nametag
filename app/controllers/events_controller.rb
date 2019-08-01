class EventsController < ApplicationController

  before_action :redirect_if_no_login
  before_action :access_event, only: [:show, :edit, :update, :destroy]
  before_action :find_user, only: [:create, :update]
  before_action :user_admin_level, only: [:index, :new, :create, :edit]

  def index
    if params[:contact_id]
      @contact = Contact.find(params[:contact_id])
      @events = @contact.events
    else
      @events = Event.access(@user_admin_level)
    end
  end

  def new
    @event = Event.new
  end

  def create
    date = Event.collect_date(event_params)
    @event = Event.new(name: event_params[:name], date: date, guest_count: event_params[:guest_count], staff_count: event_params[:staff_count])
    @event.admin_level = @user_admin_level
    if @event.save
      Contact.add_contacts(event_params, @event, @user)
      redirect_to event_path(@event)
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    date = Event.collect_date(event_params)
    @event.update(name: event_params[:name], date: date, guest_count: event_params[:guest_count], staff_count: event_params[:staff_count])
    Contact.add_contacts(event_params, @event, @user)
    if @event.save then redirect_to event_path(@event) else render :edit end
  end

  def destroy
    @event.delete
    redirect_to events_path
  end

  private
  def event_params
    params.require(:event).permit(:name, :date, :guest_count, :staff_count, contact_ids:[])
  end

  def find_event
    @event = Event.find(params[:id])
  end

  def access_event
    find_event
    if !has_access?(@event.try(:admin_level))
      flash.now[:alert] = "You cannot edit/view this event."
      redirect_to events_path
    end
  end

  def find_user
    @user = current_user
  end
end
