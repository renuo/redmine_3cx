require_relative "../../app/models/contact_serializer"
require "csv"
require "debug"

namespace :redmine_3cx do
  desc "Export contacts to CSV"
  task export: :environment do
    contacts = Contact.all

    puts "Exporting contacts to tmp/contacts.csv..."

    CSV.open("tmp/contacts.csv", "w") do |csv|
      csv << [
        :FirstName, :LastName, :Company, :Mobile, :Mobile2, :Home, :Home2, :Business, :Business2, :Email, :Other, :BusinessFax, :HomeFax, :Pager
      ]

      contacts.each do |contact|
        phones = ContactSerializer.map_phone_numbers_to_keys(contact.phones)

        has_phones = phones.values.any? { |phone| phone.present? }
        unless has_phones
          pp "Skipping contact #{contact.first_name} #{contact.last_name} (no phone numbers)..."
          next
        end

        puts "Adding contact #{contact.first_name} #{contact.last_name}..."

        csv << [contact.first_name, contact.last_name, contact.company, phones[:phone_mobile], phones[:phone_mobile2], phones[:phone_home], phones[:phone_home2], phones[:phone_business],
                phones[:phone_business2],]
      end
    end

    puts "Done!"
  end
end
