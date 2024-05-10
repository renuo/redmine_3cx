require_relative "../test_helper"

class CrmApiControllerTest < ActionController::TestCase
  include FactoryBot::Syntax::Methods
  include Benchmarker

  def setup
    @contact = create(:contact)
    @expected_contact_response = {
      "contacts" => [{
        "id" => @contact.id,
        "firstname" => "John",
        "lastname" => "Doe",
        "company" => "Example AG",
        "phone_business" => "0781234567"
      }]
    }.to_json
  end

  def test_index
    assert_index_response(@contact.phone, :success, @expected_contact_response)
  end

  def test_index_alternate_phone_format
    assert_index_response("+41 (0) 78 123 45 67 ", :success, @expected_contact_response)
  end

  def test_index_param_not_present
    assert_index_response(nil, :bad_request, {error: "Phone number is required!"}.to_json)
  end

  def test_index_not_found
    assert_index_response("Nonexistent", :success, {contacts: []}.to_json)
  end

  def test_performance
    create_list(:contact, 200, phone: "other")
    benchmark("CrmApiController#index", percentile: 95, max_time_ms: 100, runs: 1000) { get_contact_assert_success }
  end

  private

  def get_contact(phone)
    get :index, params: {phone: phone}, format: :json
  end

  def assert_index_response(phone, status, expected_response)
    get_contact(phone)
    assert_response status
    assert_includes "application/json; charset=utf-8", response.content_type
    assert_equal expected_response, response.body
  end

  def get_contact_assert_success
    get_contact(@contact.phone)
    assert_response :success
  def test_truth
    assert true
  def setup
    @contact = create(:contact)
  end

  def test_show
    get_show_page
    assert_response :success
    assert_includes "application/json; charset=utf-8", response.content_type

    assert_equal json_response, {
      "contact" => {
        "id" => @contact.id,
        "firstname" => "John",
        "lastname" => "Doe",
        "phone" => "1234567890"
      }
    }
  end

  def test_show_not_found
    get :show, params: {phone: "not-found"}, format: :json
    assert_response :not_found
    assert_equal response.body, {error: "Not found"}.to_json
  end

  def test_performance
    percentile = 95
    n = 100 / (100 - percentile)

    max_response_time_ms = 100

    results = n.times.map { benchmark_show_call }
    error_message = "Rendering the show page in the #{percentile}th percentile took more than #{max_response_time_ms}ms"
    assert results.sort[-2] < max_response_time_ms, error_message
  end

  private

  def get_show_page
    get :show, params: {phone: @contact.phone}, format: :json
  end

  def benchmark_show_call
    Benchmark.ms do
      get_show_page
      assert_response :success
    end
  end
end
