class CrmApiController < ApplicationController
  before_action :validate_params, :find_users, only: [:index]

  def index
    render json: {contacts: @contacts.map { |c| ContactSerializer.call(c) }}
  end

  private

  def validate_params
    if params[:phone].blank?
      render json: {error: "Phone number is required!"}, status: :bad_request
    end
  end

  def find_users
    phone_number = ContactSerializer.map_phone_number(params[:phone])

    @contacts = Contact.all.filter do |contact|
      contact.phones.map { |phone| ContactSerializer.map_phone_number(phone) }.include?(phone_number)
    end
  end

  private

  def find_contact
    @contact = Contact.find_by(phone: params[:phone])

    render json: {error: "Not found"}, status: :not_found if @contact.nil?
  end
end
