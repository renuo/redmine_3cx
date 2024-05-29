require_relative "../test_helper"
require "nokogiri"

class CrmTemplateControllerTest < ActionController::TestCase
  fixtures :users

  def test_template_response
    @request.session[:user_id] = 1
    get :template
    assert_response :success
    assert_includes @response.content_type, "application/xml"
    assert_template "crm_template/template.xml"
  end

  def test_template_valid_xml
    @request.session[:user_id] = 1
    get :template, format: :xml
    doc = Nokogiri::XML(@response.body)
    assert_empty doc.errors
  end

  def test_template_contents
    @request.session[:user_id] = 1
    get :template
    options = Nokogiri::XML::ParseOptions.new(Nokogiri::XML::ParseOptions::NOBLANKS)

    doc = Nokogiri::XML(@response.body, nil, nil, options)
    assert_equal "Crm", doc.root.name
    assert_not_nil doc.at_xpath("//Authentication")
    assert_not_nil doc.at_xpath("//Scenarios")
  end

  def test_not_admin
    @request.session[:user_id] = 2
    get :template, format: :xml
    assert_response :forbidden
  end
end
