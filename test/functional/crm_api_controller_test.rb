require_relative "../test_helper"

class CrmApiControllerTest < ActionController::TestCase
  def setup
    @contact = create(:contact)
  end

  def test_show
    get :show, format: :json
    assert_response :success
    assert_equal "application/json", response.content_type

    assert_equal json_response, {
      "contact" => {
        "id" => @contact.id,
        "firstname" => "John",
        "lastname" => "Doe",
        "phone" => "1234567890"
      }
    }
  end
end
