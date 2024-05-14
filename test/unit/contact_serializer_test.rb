require_relative "../test_helper"

class ContactSerializerTest < ActiveSupport::TestCase
  include FactoryBot::Syntax::Methods
  def setup
    @phones = [
      ["+41 76 123 45 67", "0761234567"],
      ["041 34 890 12 34", "0348901234"],
      ["+41 (0)79 555 45 78", "0795554578"],
      ["079 456 78 90", "0794567890"],
      ["+41 (0)31 456 78 90", "0314567890"],
      ["044 234 56 78", "0442345678"]
    ]
    @contact = create(:contact, phone: "+41 76 123 45 67, 041 34 890 12 34, +41 (0)79 555 45 78, 079 456 78 90, +41 (0)31 456 78 90, 044 234 56 78")
  end

  def test_phones
    @phones.each do |phone, expected|
      assert_equal(expected, ContactSerializer.map_phone_number(phone))
    end
  end

  def test_add_phone_numbers
    assert_equal({}, ContactSerializer.map_phone_numbers_to_keys([]))
    assert_equal({phone_business: "1234567890"}, ContactSerializer.map_phone_numbers_to_keys(["1234567890"]))
  end
end
