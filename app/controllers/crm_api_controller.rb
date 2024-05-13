class CrmApiController < ApplicationController
  before_action :validate_params, :find_user, only: [:show]

  def show
    render json: {contact: {
      firstname: @contact.first_name,
      lastname: @contact.last_name,
      company: @contact.company,
      phone: @contact.phone
    }}
  end

  private

  def validate_params
    if params[:phone].blank?
      render json: {error: "Phone number is required!"}, status: :bad_request
    end
  end

  def find_user
    @contact = Contact.find_by(phone: params[:phone])

    if @contact.nil?
      render json: {error: "Not found!"}, status: :not_found
    end
  end
end
