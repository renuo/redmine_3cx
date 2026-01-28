class ContactSerializer
  PHONE_NUMBER_KEYS = [:phone_business, :phone_business2, :phone_home, :phone_home2, :phone_mobile, :phone_other]

  MAPPING = {
    0 => :phone_business,
    1 => :phone_business2,
    2 => :phone_home,
    # 0 => :phone_home2,
    3 => :phone_mobile,
    4 => :phone_mobile2,
    5 => :phone_other,
  }

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
      contact_hash.merge(phone_numbers.compact)
    end

    def contact_number(contact, number_kind)
      reverse_mapping =  ContactSerializer::MAPPING.map { |k,v| [v,k] }.to_h
phone_number =       contact.phones[reverse_mapping.fetch(number_kind) do
        raise "'#{number_kind}' is not included in [ #{reverse_mapping.keys.join(' ')} ]"
      end]

      return nil if phone_number.nil?

      normalize_phone_number(phone_number)
    end

    def map_phone_numbers_to_keys(phone_numbers)
      normalized_numbers = phone_numbers.map { |phone_number| normalize_phone_number(phone_number) }
      PHONE_NUMBER_KEYS.zip(normalized_numbers).to_h
    end

    def normalize_phone_number(phone_number)
      phone_number.gsub(/[^+0-9]/, "").gsub(/^[+0]41/, "").rjust(10, "0")
    end
  end
end
