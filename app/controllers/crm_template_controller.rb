class CrmTemplateController < ApplicationController
  before_action :require_admin

  def template
    render "crm_template/template.xml", content_type: "application/xml"
  end
end
