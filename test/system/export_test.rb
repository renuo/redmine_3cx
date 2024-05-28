require_relative "../test_helper"

class ExportTest < ActiveSupport::TestCase
  include FactoryBot::Syntax::Methods

  fixtures :roles, :users

  def setup
    @contacts = create_list(:contact, 5)
    @contacts[0].update!(phone: "")
    Rake::Task["redmine_3cx:export"].invoke
    @csv = CSV.read("tmp/contacts.csv")
  end

  def test_csv_contents
    assert_equal <<~CSV, File.read("tmp/contacts.csv")
      FirstName,LastName,Company,Business,Business2,Home,Home2,Mobile,Mobile2,Other
      John,Doe,Example AG,0781234567,,,,,,
      John,Doe,Example AG,0781234567,,,,,,
      John,Doe,Example AG,0781234567,,,,,,
      John,Doe,Example AG,0781234567,,,,,,
    CSV
  end
end
