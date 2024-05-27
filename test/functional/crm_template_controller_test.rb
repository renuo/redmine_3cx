require_relative "../test_helper"
require "nokogiri"

class CrmTemplateControllerTest < ActionController::TestCase
  def setup
    get :template, format: :xml
  end

  def test_template_response
    assert_includes @response.content_type, "application/xml"
    assert_template "crm_template/template"
    assert_response :success
  end

  def test_template_valid_xml
    doc = Nokogiri::XML(@response.body)
    assert_empty doc.errors
  end

  def test_template_contents
    assert_includes @response.body, "<Crm"
    assert_includes @response.body, "<Scenarios"
    assert_includes @response.body, "<Scenarios"
    assert_includes @response.body, "contacts.id"
    assert_includes @response.body, "contacts.firstname"
    assert_includes @response.body, "contacts.lastname"
    assert_includes @response.body, "contacts.company"
  end
end
