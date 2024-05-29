class CrmApiController < ApplicationController
  before_action :authorize_global, :check_plugin_state, :find_contacts, only: [:index]
  accept_api_auth :index

  def index
    render json: {contacts: @contacts.map { |c| ContactSerializer.call(c) }}
  end

  private

  def check_plugin_state
    unless Setting[:plugin_redmine_3cx][:active]
      render json: {error: "Plugin not active"}, status: :forbidden
    end
  end

  def phone_params
    params.require(:phone)
  end

  def find_contacts
    phone_number = ContactSerializer.normalize_phone_number(phone_params)

    @contacts = Contact.joins(:projects).filter do |contact|
      contact.phones.map { |phone| ContactSerializer.normalize_phone_number(phone) }.include?(phone_number)
    end.filter do |contact|
      User.current.allowed_to?(:use_api, contact.project)
    end
  end
end
