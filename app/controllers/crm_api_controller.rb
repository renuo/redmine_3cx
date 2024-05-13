class CrmApiController < ApplicationController
  before_action :find_user, only: [:show]

  def show
    render json: {contact: {
      firstname: @contact.first_name,
      lastname: @contact.last_name,
      company: @contact.company,
      phone: @contact.phone
    }}
  end

  private

  def find_user
    @contact = Contact.find_by(phone: params[:phone])

    if @contact.nil?
      render json: {error: "Not found"}, status: :not_found
    end
  end
end
