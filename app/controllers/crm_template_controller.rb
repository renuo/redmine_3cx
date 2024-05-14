class CrmTemplateController < ApplicationController
  def template
    stream = render_to_string(template: "crm_template/template")
    send_data(stream, type: "application/xml", filename: "template.xml")
  end
end
