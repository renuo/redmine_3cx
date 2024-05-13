require_relative "../test_helper"

class CrmApiControllerTest < ActionController::TestCase
  include FactoryBot::Syntax::Methods
  include Benchmarker

  def setup
    @contact = create(:contact)
  end

  def test_show
    get_contact
    assert_response :success
    assert_includes "application/json; charset=utf-8", response.content_type

    assert_equal response.body, {
      "contact" => {
        "firstname" => "John",
        "lastname" => "Doe",
        "company" => "Example AG",
        "phone" => "1234567890"
      }
    }.to_json
  end

  def test_show_param_not_present
    get_contact(phone: nil)

    assert_response :bad_request
    assert_equal response.body, {error: "Phone number is required!"}.to_json
  end

  def test_show_not_found
    get_contact(phone: "Nonexistent")
    assert_response :not_found
    assert_equal response.body, {error: "Not found!"}.to_json
  end

  def test_performance
    benchmark("Render show page", percentile: 95, max_time_ms: 100, runs: 1000) do
      get_contact
      assert_response :success
    end
  end

  private

  def get_contact(params = {phone: @contact.phone})
    get :show, params:, format: :json
  end
end
