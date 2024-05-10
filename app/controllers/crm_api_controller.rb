class CrmApiController < ApplicationController
  def show
    @contact = Contact.find_by(phone: params[:phone])

    if @contact.nil?
      return render json: {error: "Not found"}, status: :not_found
    end

    render json: {contact: {
      firstname: @contact.first_name,
      lastname: @contact.last_name,
      phone: @contact.phone
    }}
  end
end
