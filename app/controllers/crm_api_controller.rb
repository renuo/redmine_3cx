class CrmApiController < ApplicationController
  before_action :validate_params, :find_user, only: [:show]

  def show
    render json: {contacts: @contacts.map { |contact| map_contact(contact) }}
  end

  private

  def map_contact(contact)
    phones = contact.phones.map { |p| map_phone_number(p) }

    {
      id: contact.id,
      firstname: contact.first_name,
      lastname: contact.last_name,
      company: contact.company,
      phone: phones[0],
      phone1: phones[1],
      phone2: phones[2]
    }
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
