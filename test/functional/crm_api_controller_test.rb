require_relative "../test_helper"

class CrmApiControllerTest < ActionController::TestCase
  include FactoryBot::Syntax::Methods
  include Benchmarker

  fixtures :roles

  def setup
    Setting.rest_api_enabled = "1"
    project = create(:project)
    @contact = create(:contact, project: project)

    @user = create(:user)
    @user.memberships.create(project: project)
    @user.memberships.last.roles << Role.find_or_create_by(name: "3CX API User", permissions: [:use_api])
    @user.memberships.last.save!
    @api_key = @user.api_key
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

  def test_show_invalid_credentials
    get_show_page(api_key: "Invalid")
    assert_response :unauthorized
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
    get_show_page(phone: "Nonexistent")
    assert_response :not_found
    assert_equal response.body, {error: "Not found"}.to_json
  end

  def test_performance
    benchmark("Render show page", percentile: 95, max_time_ms: 100, runs: 1000) do
      get_show_page
      assert_response :success
    end
  end

  private

  def get_show_page(phone: @contact.phone, api_key: @api_key)
    headers = {"HTTP_AUTHORIZATION" => ActionController::HttpAuthentication::Basic.encode_credentials(api_key, "empty")}
    @request.headers.merge! headers
    get :show, params: {phone: phone}, format: :json
  end
end
