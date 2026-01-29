namespace :redmine_3cx do
  desc <<-DESC
    Call Contacts API

    Example:
      rake redmine_3cx:call_api phone="+41 78 111 22 33"
  DESC

  task call_api: :environment do
    require 'uri'
    require 'net/http'

    phone = ENV["phone"]
    url = URI("http://localhost:3000/3cx/contacts.json?phone=#{URI.encode_uri_component(phone)}")

    user = User.find_by!(login: "service_account")

    http = Net::HTTP.new(url.host, url.port)

    credentials = "#{user.api_key}:x"
    request = Net::HTTP::Get.new(url)
    request["authorization"] = "Basic #{Base64.encode64(credentials).chomp}"

    response = http.request(request)
    json = JSON.parse(response.read_body)
    puts JSON.pretty_generate(json)
  end
end

