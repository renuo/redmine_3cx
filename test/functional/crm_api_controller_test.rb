require_relative "../test_helper"

class CrmApiControllerTest < ActionController::TestCase
  include FactoryBot::Syntax::Methods
  def setup
    @contact = create(:contact)
  end

  def test_show
    get :show, params: {phone: "1234567890"}, format: :json
    assert_response :success
    assert_equal "application/json; charset=utf-8", response.content_type

    assert_equal response.body, {
      "contact" => {
        "firstname" => "John",
        "lastname" => "Doe",
        "phone" => "1234567890"
      }
    }.to_json
  end
end
