require_relative "../../app/models/contact_serializer"
require "csv"

FILE_PATH = "tmp/contacts.csv"
CONTACT_KEYS = [:first_name, :last_name, :company]
PHONE_KEYS = ContactSerializer::PHONE_NUMBER_KEYS

namespace :redmine_3cx do
  desc "Export contacts to CSV file"
  task export: :environment do
    contacts = Contact.all
    local_path = File.expand_path(FILE_PATH)
    File.delete(FILE_PATH) if File.exist?(FILE_PATH)
    puts "Exporting contacts to #{local_path}"

    CSV.open(FILE_PATH, "w", row_sep: "\r\n") do |csv|
      csv.truncate(0)
      csv << csv_headers
      contacts.each do |contact|
        export_contact(csv, contact)
      end
    end
    puts "Done!"
  end

  desc "Export contacts to CSV stream"
  task to_csv: :environment do
    output_string = CSV.generate("", headers: csv_headers, write_headers: true, row_sep: "\r\n") do |csv|
      Contact.all.each do |contact|
        export_contact_silent(csv, contact)
      end
    end

    puts output_string
  end
end

def to_pascal_case(str)
  str.split("_").map(&:capitalize).join
end

def csv_headers
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

def export_contact_silent(csv, contact)
  phones = ContactSerializer.map_phone_numbers_to_keys(contact.phones)
  return if phones.values.none?(&:present?)

  csv << contact_row(contact, phones)
end

def contact_row(contact, phones)
  [
    *CONTACT_KEYS.map { |key| contact[key] },
    *PHONE_KEYS.map { |key| phones[key] }
  ]
end
