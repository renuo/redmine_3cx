class CrmApiController < ApplicationController
  before_action :authorize_global, :check_plugin_state
  before_action :find_contacts_by_phone, only: [:lookup]
  before_action :find_contacts_by_query, only: [:search]

  rescue_from ActionController::ParameterMissing, with: :render_missing_param

  accept_api_auth :lookup, :search

  def lookup
    render_contacts
  end

  def search
    render_contacts
  end

  private

  def render_contacts
    render json: {contacts: @contacts.map { |c| ContactSerializer.call(c) }}
  end

  def render_missing_param(exception)
    render json: {error: exception.message}, status: :bad_request
  end

  def check_plugin_state
    unless Setting[:plugin_redmine_3cx][:active]
      render json: {error: "Plugin not active"}, status: :forbidden
    end
  end

  def phone_params
    params.require(:phone)
  end

  def query_params
    params.require(:query)
  end

  def find_contacts_by_query
    @contacts = Contact.joins(:projects).live_search(query_params).order(:is_company).filter do |contact|
      User.current.allowed_to?(:use_api, contact.project)
    end
  end

  def find_contacts_by_phone
    phone_number = ContactSerializer.normalize_phone_number(phone_params)

    @contacts = Contact.joins(:projects).order(:is_company).filter do |contact|
      contact.phones.map { |phone| ContactSerializer.normalize_phone_number(phone) }.include?(phone_number)
    end.filter do |contact|
      User.current.allowed_to?(:use_api, contact.project)
    end
  end
end
