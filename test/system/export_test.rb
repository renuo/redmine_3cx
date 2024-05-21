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

  def test_missing_phone_numbers
    assert @csv.none? { |row| row[3..].all? { |cell| cell.blank? } }
  end

  def test_row_count
    assert @csv.count == 5
  end

  def test_headers
    assert @csv.first == ["FirstName", "LastName", "Company", "Business", "Business2", "Home", "Home2", "Mobile", "Mobile2", "Other"]
  end

  def test_empty_rows
    assert @csv.none? { |row| row.all? { |cell| cell.empty? } }
  end
end
