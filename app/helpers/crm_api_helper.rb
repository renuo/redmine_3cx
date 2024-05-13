module CrmApiHelper
  def plugin_compatible
    if defined?(Contact)
      contact = Contact.new
      contact.respond_to?(:first_name) && contact.respond_to?(:last_name) && contact.respond_to?(:phone) && contact.respond_to?(:company)
    else
      false
    end
  end
end
