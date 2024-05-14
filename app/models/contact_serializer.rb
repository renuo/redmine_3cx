class ContactSerializer
  class << self
    PHONE_NUMBER_KEYS = [:phone_business, :phone_business2, :phone_home, :phone_home2, :phone_mobile, :phone_mobile2, :phone_other]

    def call(contact)
      contact_hash = {
        id: contact.id,
        firstname: contact.first_name,
        lastname: contact.last_name,
        company: contact.company
      }

      phone_numbers = map_phone_numbers_to_keys(contact.phones)
      contact_hash.merge(phone_numbers)
    end

    def map_phone_numbers_to_keys(phone_numbers)
      PHONE_NUMBER_KEYS.each_with_index.each_with_object({}) do |(key, index), hash|
        return hash unless phone_numbers[index]

        return hash.merge(key => map_phone_number(phone_numbers[index]))
      end
    end

    def map_phone_number(phone_number)
      phone_number.gsub(/^[+0]41/, "").gsub(/\D/, "").rjust(10, "0")
    end
  end
end
