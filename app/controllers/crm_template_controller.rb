class CrmTemplateController < ApplicationController
  def show
    stream = render_to_string(template: "template/show")
    send_data(stream, type: "text/xml", filename: "template.xml")
  end
end
