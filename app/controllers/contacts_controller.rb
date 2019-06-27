class ContactsController < ApplicationController
  def index
  end

  def new
    @contact = Contact.new
  end

  def create
    contact = Contact.new(contact_params)
    if contact.save
      redirect_to contact_path(contact)
    else
      render :new
    end
  end

  def show
    @contact = Contact.find(params[:id])
  end

  def edit
    @contact = Contact.find(params[:id])
  end

  def update
  end

  def destroy
  end

  private
  def contact_params
    params.require(:contact).permit(:name, :email, :gender, :user_id, :phone_number, :school_status, :messenger_company, :messenger_id, :major, :country, :birthday)
  end
end
