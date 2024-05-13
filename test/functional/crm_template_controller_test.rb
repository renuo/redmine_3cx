require_relative "../test_helper"

class CrmTemplateControllerTest < ActionController::TestCase
  def test_template_response
    get :index, format: :xml
    assert_includes response.content_type, "application/xml"
    assert_response :success
  end

  def test_template_contents
    get :index, format: :xml
    assert_includes response.body, "<Crm"
    assert_includes response.body, '<Authentication Type="Basic">'
    assert_includes response.body, "<Scenarios"
    assert_includes response.body, '<Scenario Type="REST">'
    assert_includes response.body, '<Scenario Id="CreateContactRecord" Type="REST">'
  end
end
