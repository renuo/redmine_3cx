require_relative "../test_helper"
require "nokogiri"

class CrmTemplateControllerTest < ActionController::TestCase
  def test_template_response
    get :template, format: :xml
    assert_includes @response.content_type, "application/xml"
    assert_template "crm_template/template"
    assert_response :success
  end

  def test_template_valid_xml
    get :template, format: :xml
    doc = Nokogiri::XML(@response.body)
    assert_empty doc.errors
  end

  def test_template_contents
    get :template, format: :xml
    options = Nokogiri::XML::ParseOptions.new(Nokogiri::XML::ParseOptions::NOBLANKS)

    doc = Nokogiri::XML(@response.body, nil, nil, options)
    assert_equal "Crm", doc.root.name
    assert_not_nil doc.at_xpath("//Authentication")
    assert_not_nil doc.at_xpath("//Scenarios")
  end
end
