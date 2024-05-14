require_relative "../test_helper"

class CrmApiControllerTest < ActionController::TestCase
  include FactoryBot::Syntax::Methods
  include Benchmarker

  fixtures :roles, :users

  def setup
    Setting.rest_api_enabled = "1"
    project = create(:project)
    project.enable_module! :contacts

    @user = create(:user)
    @user.memberships.create(project: project)
    @user.memberships.last.roles << Role.find_or_create_by(name: "3CX API User", permissions: [:use_api])
    @user.memberships.last.save!
    @api_key = @user.api_key

    @contact = create(:contact, project: project)

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
    get_contact_assert_success
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
    create_list(:contact, 100, phone: "other")
    benchmark("CrmApiController#index", percentile: 95, max_time_ms: 100, runs: 200) { get_contact_assert_success }
  end

  def test_index_invalid_credentials
    assert_index_response(@contact.phone, :unauthorized, "", api_key: "Invalid")
  end

  def test_index_non_project_member
    other_project = create(:project)
    other_contact = create(:contact, phone: "0123456789", project: other_project)

    assert_index_response(other_contact.phone, :success, {contacts: []}.to_json)
  end

  private

  def get_contact_assert_success
    assert_index_response(@contact.phone, :success, @expected_contact_response)
  end

  def assert_index_response(phone, status, expected_response, api_key: @api_key)
    get_contact(phone, api_key)
    assert_response status
    assert_includes "application/json; charset=utf-8", response.content_type
    assert_equal expected_response, response.body
  end

  def get_contact(phone, api_key = @api_key)
    headers = {"HTTP_AUTHORIZATION" => ActionController::HttpAuthentication::Basic.encode_credentials(api_key, "x")}
    @request.headers.merge! headers
    get :index, params: {phone: phone}, format: :json
  end
end
