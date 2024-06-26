require_relative "../../app/models/contact_serializer"
require "csv"

FILE_PATH = "tmp/contacts.csv"
CONTACT_KEYS = [:first_name, :last_name, :company]
PHONE_KEYS = ContactSerializer::PHONE_NUMBER_KEYS

namespace :redmine_3cx do
  desc "Export contacts to CSV"
  task export: :environment do
    contacts = Contact.all
    local_path = File.expand_path(FILE_PATH)
    File.delete(FILE_PATH) if File.exist?(FILE_PATH)
    puts "Exporting contacts to #{local_path}"

    CSV.open(FILE_PATH, "w") do |csv|
      csv.truncate(0)
      csv << csv_header
      contacts.each do |contact|
        export_contact(csv, contact)
      end
    end
    puts "Done!"
  end
end

def to_pascal_case(str)
  str.split("_").map(&:capitalize).join
end

def csv_header
  [
    *CONTACT_KEYS.map { |key| to_pascal_case(key.to_s) },
    *PHONE_KEYS.map { |key| to_pascal_case(key.to_s.gsub("phone_", "")) }
  ]
end

def export_contact(csv, contact)
  phones = ContactSerializer.map_phone_numbers_to_keys(contact.phones)
  if phones.values.none?(&:present?)
    puts "Skipping contact #{contact.first_name} #{contact.last_name} (no phone numbers)..."
    return
  end
  puts "Adding contact #{contact.first_name} #{contact.last_name}..."
  csv << contact_row(contact, phones)
end

def contact_row(contact, phones)
  [
    *CONTACT_KEYS.map { |key| contact[key] },
    *PHONE_KEYS.map { |key| phones[key] }
  ]
end
