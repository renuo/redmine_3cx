require_relative "../test_helper"

class ContactSerializerTest < ActiveSupport::TestCase
  include FactoryBot::Syntax::Methods

  def setup
    @contact = create(:contact, phone: "1,2,3,4,5,6,7,8")
  end

  def test_serialization
    expected = {
      id: @contact.id,
      firstname: "John",
      lastname: "Doe",
      company: "Example AG",
      phone_business: "0000000001",
      phone_business2: "0000000002",
      phone_home: "0000000003",
      phone_home2: "0000000004",
      phone_mobile: "0000000005",
      phone_mobile2: "0000000006",
      phone_other: "0000000007"
    }
    assert_equal(expected, ContactSerializer.call(@contact))
  end

  def test_call_without_phones
    @contact.phones = []
    assert_equal [:id, :firstname, :lastname, :company], ContactSerializer.call(@contact).keys
  end

  def test_phone_normalization
    [
      ["0761234567", "+41 76 123 45 67"],
      ["0348901234", "041 34 890 12 34"],
      ["0795554578", "+41 (0)79 555 45 78"],
      ["0794567890", "079 456 78 90"],
      ["0314567890", "+41 (0)31 456 78 90"],
      ["0442345678", "044 234 56 78"],
      ["0442345678", "Direkt: 044 234 56 78"]
    ].each do |expected, phone_number|
      assert_equal(expected, ContactSerializer.normalize_phone_number(phone_number))
    end
  end

  def test_add_phone_numbers
    assert_equal({}, ContactSerializer.map_phone_numbers_to_keys([]))
    assert_equal({phone_business: "1234567890"}, ContactSerializer.map_phone_numbers_to_keys(["1234567890"]))
  end
end
