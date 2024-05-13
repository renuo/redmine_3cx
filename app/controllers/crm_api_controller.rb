class CrmApiController < ApplicationController
  before_action :check_plugin_state, :authorize_global, :validate_params, :find_contacts, only: [:index]
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

    @contacts = Contact.joins(:projects).filter do |contact|
      contact.phones.map { |phone| ContactSerializer.map_phone_number(phone) }.include?(phone_number)
    end.filter do |contact|
      User.current.allowed_to?(:use_api, contact.project)
    end
  end

  def check_plugin_state
    unless Setting[:plugin_redmine_3cx][:active]
      render json: {error: "Plugin not active"}, status: :forbidden
    end
  end
end
