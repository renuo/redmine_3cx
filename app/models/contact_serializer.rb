class ContactSerializer
  PHONE_NUMBER_KEYS = [:business, :business2, :home, :home2, :mobile, :mobile2, :other]

  class << self
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
      PHONE_NUMBER_KEYS.each_with_index.with_object({}) do |(key, index), result|
        phone_number = phone_numbers[index]
        result[:"phone_#{key}"] = normalize_phone_number(phone_number) if phone_number
      end
    end

    def normalize_phone_number(phone_number)
      phone_number.gsub(/[^+0-9]/, "").gsub(/^[+0]41/, "").rjust(10, "0")
    end
  end
end
