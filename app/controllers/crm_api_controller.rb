class CrmApiController < ApplicationController
  def show
    @contact = Contact.find_by(params[:phone])
    render json: {contact: {
      firstname: @contact.first_name,
      lastname: @contact.last_name,
      phone: @contact.phone
    }}
  end
end
