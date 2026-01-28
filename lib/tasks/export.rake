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

    CSV.open(FILE_PATH, "w", row_sep: "\r\n") do |csv|
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

def csv_header
  %w[FirstName LastName Company Mobile Mobile2 Home Title Business Business2 Email Other BusinessFax Department Pager]
end

def csv_row(contact)
  number = ->(kind) { ContactSerializer.contact_number(contact, kind)}
{
  FirstName: contact.first_name,
  LastName: contact.last_name,
  Company: contact.company,
  Mobile: number.call(:phone_mobile),
  Mobile2: number.call(:phone_mobile2),
  Home: number.call(:phone_home),
  Title: nil,
  Business: number.call(:phone_business),
  Business2: number.call(:phone_business2),
  Email: contact.email,
  Other: nil,
  BusinessFax: nil,
  Department: nil,
  Pager: nil,
}.values
end

def export_contact(csv, contact)
  phones = ContactSerializer.map_phone_numbers_to_keys(contact.phones)
  if phones.values.none?(&:present?)
    puts "Skipping contact #{contact.first_name} #{contact.last_name} (no phone numbers)..."
    return
  end
  puts "Adding contact #{contact.first_name} #{contact.last_name}..."
  csv << contact_row(contact, phones)
  # csv << csv_row(contact)
end

def contact_row(contact, phones)
  [
    *CONTACT_KEYS.map { |key| contact[key] },
    *PHONE_KEYS.map { |key| phones[key] }
  ]
end
