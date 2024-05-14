class CrmApiController < ApplicationController
  before_action :authorize_global, :validate_params, :find_contacts, only: [:index]
  accept_api_auth :index

  def index
    render json: {contacts: @contacts.map { |c| ContactSerializer.call(c) }}
  end

  private

  def validate_params
    if params[:phone].blank?
      render json: {error: "Phone number is required!"}, status: :bad_request
    end
  end

  def find_contacts
    phone_number = ContactSerializer.map_phone_number(params[:phone])

    @contacts = Contact.all.filter do |contact|
      contact.phones.map { |phone| ContactSerializer.map_phone_number(phone) }.include?(phone_number)
    end.filter do |contact|
      User.current.allowed_to?(:use_api, contact.project)
    end
  end
end
