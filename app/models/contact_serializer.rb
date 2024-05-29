class ContactSerializer
  PHONE_NUMBER_KEYS = [:phone_business, :phone_business2, :phone_home, :phone_home2, :phone_mobile, :phone_mobile2, :phone_other]

  class << self
    def call(contact)
      contact_hash = {
        id: contact.id,
        firstname: contact.first_name,
        lastname: contact.last_name,
        company: contact.company
      }

      # Phone numbers stored as an array in the database without an annotation.
      # We map them in the order they are stored, as defined by the PHONE_NUMBER_KEYS constant.
      phone_numbers = map_phone_numbers_to_keys(contact.phones)
      contact_hash.merge(phone_numbers)
    end

    def map_phone_numbers_to_keys(phone_numbers)
      PHONE_NUMBER_KEYS.each_with_index.with_object({}) do |(key, index), result|
        phone_number = phone_numbers[index]
        result[key] = normalize_phone_number(phone_number) if phone_number
      end
    end

    def normalize_phone_number(phone_number)
      phone_number.gsub(/[^+0-9]/, "").gsub(/^[+0]41/, "").rjust(10, "0")
    end
  end
end
