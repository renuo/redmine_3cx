require_relative "../../app/models/contact_serializer"
require "csv"
require "debug"

FILE_PATH = "tmp/contacts.csv"

CONTACT_KEYS = [:first_name, :last_name, :company]
PHONE_KEYS = ContactSerializer::PHONE_NUMBER_KEYS

def to_pascal_case(str)
  str.split("_").map(&:capitalize).join
end

namespace :redmine_3cx do
  desc "Export contacts to CSV"
  task export: :environment do
    contacts = Contact.all

    puts "Exporting contacts to tmp/contacts.csv..."

    mode = File.exist?(FILE_PATH) ? "a+" : "w"

    CSV.open(FILE_PATH, mode) do |csv|
      csv.truncate(0)

      csv << [
        *CONTACT_KEYS.map { |key| to_pascal_case(key.to_s) },
        *PHONE_KEYS.map { |key| to_pascal_case(key.to_s) }
      ]

      contacts.each do |contact|
        phones = ContactSerializer.map_phone_numbers_to_keys(contact.phones)

        has_phones = phones.values.any? { |phone| phone.present? }

        unless has_phones
          pp "Skipping contact #{contact.first_name} #{contact.last_name} (no phone numbers)..."
          next
        end

        puts "Adding contact #{contact.first_name} #{contact.last_name}..."

        csv << [
          *CONTACT_KEYS.map { |key| contact[key] },
          *PHONE_KEYS.map { |key| phones[:"phone_#{key}"] }
        ]
      end
    end

    puts "Done!"
  end
end
