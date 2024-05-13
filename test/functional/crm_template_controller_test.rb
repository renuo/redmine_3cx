require_relative "../test_helper"
require "nokogiri"

class CrmTemplateControllerTest < ActionController::TestCase
  def setup
    get :show, format: :xml
  end

  def test_template_response
    assert_includes @response.content_type, "application/xml"
    assert_template "crm_template/show"
    assert_response :success
  end

  def test_template_valid_xml
    doc = Nokogiri::XML(@response.body)
    assert_empty doc.errors
  end

  def test_template_contents
    assert_includes @response.body, "<Crm"
    assert_includes @response.body, '<Authentication Type="Basic">'
    assert_includes @response.body, "<Scenarios"
    assert_includes @response.body, '<Scenario Type="REST">'
    assert_includes @response.body, '<Scenario Id="CreateContactRecord" Type="REST">'
  end
end
