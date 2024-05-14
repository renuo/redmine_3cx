class CrmApiController < ApplicationController
  before_action :validate_params, :find_user, only: [:show]

  def show
    render json: {contacts: @contacts.map { |c| ContactSerializer.call(c) }}
  end

  private

  def validate_params
    if params[:phone].blank?
      render json: {error: "Phone number is required!"}, status: :bad_request
    end
  end

  def find_user
    phone_number = ContactSerializer.map_phone_number(params[:phone])

    @contacts = Contact.all.filter do |contact|
      contact.phones.map { |phone| ContactSerializer.map_phone_number(phone) }.include?(phone_number)
    end
  end
end
