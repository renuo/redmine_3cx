class CrmApiController < ApplicationController
  before_action :validate_params, :find_user, only: [:show]

  def show
    render json: {contacts: @contacts.map { |contact| map_contact(contact) }}
  end

  private

  def map_contact(contact)
    contact_hash = {
      id: contact.id,
      firstname: contact.first_name,
      lastname: contact.last_name,
      company: contact.company
    }

    phone_keys = [:phone_business, :phone_business2, :phone_home, :phone_home2, :phone_mobile, :phone_mobile2, :phone_other]

    contact.phones.each_with_index do |phone, index|
      contact_hash[phone_keys[index]] = map_phone_number(phone)
    end

    contact_hash
  end

  def map_phone_number(phone)
    phone.gsub(/^[+0]41/, "").gsub(/\D/, "").rjust(10, "0")
  end

  def validate_params
    if params[:phone].blank?
      render json: {error: "Phone number is required!"}, status: :bad_request
    end
  end

  def find_user
    @contacts = Contact.all.filter do |contact|
      contact.phones.map { |phone| map_phone_number(phone) }.include?(map_phone_number(params[:phone]))
    end
  end
end
