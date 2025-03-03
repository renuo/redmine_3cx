require_relative "../test_helper"

class ExportTest < ActiveSupport::TestCase
  include FactoryBot::Syntax::Methods

  fixtures :roles, :users

  def setup
    require "rake"
    Rake.application.load_rakefile

    create(:contact, first_name: "Borris", last_name: "Doe", company: "Example AG")
    create(:contact, first_name: "John", last_name: "Doe", company: "Example AG", phone: "0781234567")
    create(:contact, first_name: "Other", last_name: "Person", company: "Example AG", phone: "+41 78 123 45 67, 078 123 45 67, 078 123 45 67")
    create(:contact, first_name: "Another", last_name: "Person", company: "Example AG", phone: "+41 (0) 78 123 45 67")
    create(:contact, first_name: "Yet", last_name: "Another", company: "Example AG", phone: "+41 78 123 45 67")
    Rake::Task["redmine_3cx:export"].invoke
    @csv = CSV.read("tmp/contacts.csv")
  end

  def test_csv_contents
    assert_equal <<~CSV, File.read("tmp/contacts.csv")
      FirstName,LastName,Company,Business,Business2,Home,Home2,Mobile,Mobile2,Other
      John,Doe,Example AG,0781234567,,,,,,
      Other,Person,Example AG,0781234567,0781234567,0781234567,,,,
      Another,Person,Example AG,0781234567,,,,,,
      Yet,Another,Example AG,0781234567,,,,,,
    CSV
  end
end
