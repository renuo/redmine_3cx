class CrmTemplateController < ApplicationController
  before_action :require_admin

  def template
    render :template, formats: [:xml], layout: false, content_type: "application/xml"
  end
end
