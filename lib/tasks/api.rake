namespace :redmine_3cx do
  desc <<-DESC
    Lookup contacts by phone number

    Example:
      rake redmine_3cx:phone_lookup phone="+41 78 111 22 33"
      rake redmine_3cx:phone_lookup phone="+41 78 111 22 33" login="admin" host="myapp.example.com"
  DESC

  task phone_lookup: :environment do
    phone = ENV.fetch("phone") { abort "Error: Argument 'phone' is required" }
    call_api("/3cx/lookup.json?phone=#{URI.encode_uri_component(phone)}")
  end

  desc <<-DESC
    Search contacts by query

    Example:
      rake redmine_3cx:contact_search query="John"
      rake redmine_3cx:contact_search query="John" login="admin" host="myapp.example.com"
  DESC

  task contact_search: :environment do
    query = ENV.fetch("query") { abort "Error: Argument 'query' is required" }
    call_api("/3cx/search.json?query=#{URI.encode_uri_component(query)}")
  end

  def call_api(path)
    require 'uri'
    require 'net/http'

    host = ENV.fetch("host", "localhost:3000")
    login = ENV.fetch("login", "3cx_service_account")
    url = URI("http://#{host}#{path}")

    user = User.find_by(login:)
    abort "Error: User '#{login}' not found" unless user

    http = Net::HTTP.new(url.host, url.port)
    request = Net::HTTP::Get.new(url)
    request["authorization"] = "Basic #{Base64.encode64("#{user.api_key}:x").chomp}"

    response = http.request(request)

    unless response.is_a?(Net::HTTPSuccess)
      abort "Error: Request failed with status #{response.code} #{response.message}\n#{response.body}"
    end

    begin
      json = JSON.parse(response.body)
      puts JSON.pretty_generate(json)
    rescue JSON::ParserError => e
      abort "Error: Invalid JSON response\n#{response.body}\n#{e.message}"
    end
  end
end
