xml.instruct!
xml.Crm("xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance",
  "xmlns:xsd" => "http://www.w3.org/2001/XMLSchema",
  "Country" => "US",
  "Name" => "Zendesk",
  "Version" => "25",
  "SupportsEmojis" => "true") do
  xml.Number("Prefix" => "AsIs", "MaxLength" => "[MaxLength]")
  xml.Connection("MaxConcurrentRequests" => "16")

  xml.Parameters do
    xml.tag!("Parameter", "Name" => "Email", "Type" => "String",
      "Parent" => "General Configuration",
      "Editor" => "String", "Title" => "Email:")
  end

  xml.Authentication("Type" => "Basic") do
    xml.Value("[Email]:[Password]")
  end

  xml.Scenarios do
    xml.Scenario("Type" => "REST") do
      xml.Request("Url" => "[Domain]/crm_contacts.json")
    end

    xml.Scenario("Id" => "CreateContactRecord", "Type" => "REST") do
      xml.Request("Url" => "...",
        "MessagePasses" => "0",
        "RequestEncoding" => "UrlEncoded",
        "RequestType" => "Get",
        "ResponseType" => "Json") do
        xml.Headers do
          xml.Value("Key" => "X-Zendesk-Marketplace-Name",
            "Passes" => "0",
            "Type" => "String", "_value" => "3CX")
        end
      end

      xml.Rules do
        xml.Rule("Type" => "Equals", "Ethalon" => "True", "_value" => "users.active")
      end
    end
  end
end
