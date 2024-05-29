require_relative "../test_helper"

class CrmApiControllerTest < ActionController::TestCase
  include FactoryBot::Syntax::Methods
  include Benchmarker

  fixtures :roles, :users

  def setup
    Setting.rest_api_enabled = "1"
    Setting[:plugin_redmine_3cx] = {active: true}
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
    get_contact(@contact.phone, @api_key)
    assert_response(:success)
    assert_equal(@expected_contact_response, response.body)
  end

  def test_index_inactive
    Setting[:plugin_redmine_3cx] = {active: false}
    get_contact(@contact.phone, @api_key)
    assert_response(:forbidden)
    assert_equal({error: "Plugin not active"}.to_json, response.body)
  end

  def test_index_alternate_phone_format
    get_contact("+41 (0) 78 123 45 67 ")
    assert_response(:success)
    assert_equal(@expected_contact_response, response.body)
  end

  def test_index_param_not_present
    get_contact(nil)
    assert_response(:bad_request)
    assert_equal({error: "Phone number is required!"}.to_json, response.body)
  end

  def test_index_not_found
    get_contact("Nonexistent")
    assert_response(:success)
    assert_equal({contacts: []}.to_json, response.body)
  end

  def test_performance
    create_list(:contact, 100, phone: "other")
    assert_benchmark("CrmApiController#index", percentile: 95, max_time_ms: 100, runs: 200) { get_contact_assert_success }
  end

  def test_index_invalid_credentials
    get_contact(@contact.phone, "Invalid")
    assert_response(:unauthorized)
  end

  def test_index_non_project_member
    other_project = create(:project)
    other_contact = create(:contact, phone: "0123456789", project: other_project)

    get_contact(other_contact.phone)
    assert_response(:success)
    assert_equal({contacts: []}.to_json, response.body)
  end

  private

  def get_contact_assert_success
    get_contact(@contact.phone)
    assert_response(:success)
    assert_equal(@expected_contact_response, response.body)
  end

  def get_contact(phone, api_key = @api_key)
    headers = {"HTTP_AUTHORIZATION" => ActionController::HttpAuthentication::Basic.encode_credentials(api_key, "x")}
    @request.headers.merge! headers
    get(:index, params: {phone: phone}, format: :json)
  end
end
