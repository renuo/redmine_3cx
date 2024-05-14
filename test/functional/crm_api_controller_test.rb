require_relative "../test_helper"

class CrmApiControllerTest < ActionController::TestCase
  include FactoryBot::Syntax::Methods
  include Benchmarker

  def setup
    @contact = create(:contact)
    @expected_contact_response = {
      "contacts" => [{
        "firstname" => "John",
        "lastname" => "Doe",
        "company" => "Example AG",
        "phone" => "+41 78 123 45 67"
      }]
    }.to_json
  end

  def test_show
    assert_show_response(@contact.phone, :success, @expected_contact_response)
  end

  def test_show_alternate_phone_format
    assert_show_response("0781234567", :success, @expected_contact_response)
  end

  def test_show_param_not_present
    assert_show_response(nil, :bad_request, {error: "Phone number is required!"}.to_json)
  end

  def test_show_not_found
    assert_show_response("Nonexistent", :success, {contacts: []}.to_json)
  end

  def test_performance
    benchmark("Render show page", percentile: 95, max_time_ms: 100, runs: 1000) { get_contact_assert_success }
  end

  private

  def get_contact(phone)
    get :show, params: {phone: phone}, format: :json
  end

  def assert_show_response(phone, status, expected_response)
    get_contact(phone)
    assert_response status
    assert_includes "application/json; charset=utf-8", response.content_type
    assert_equal expected_response, response.body
  end

  def get_contact_assert_success
    get_contact(@contact.phone)
    assert_response :success
  end
end
