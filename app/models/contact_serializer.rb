class ContactSerializer
  class << self
    def call(contact)
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
  end
end
