require_relative "../test_helper"

class CrmApiControllerTest < ActionController::TestCase
  include FactoryBot::Syntax::Methods
  def setup
    @contact = create(:contact)
  end

  def test_show
    get_show_page
    assert_response :success
    assert_includes "application/json; charset=utf-8", response.content_type

    assert_equal response.body, {
      "contact" => {
        "firstname" => "John",
        "lastname" => "Doe",
        "phone" => "1234567890"
      }
    }.to_json
  end

  def test_show_not_found
    get :show, params: {phone: "not-found"}, format: :json
    assert_response :not_found
    assert_equal response.body, {error: "Not found"}.to_json
  end

  def test_performance
    percentile = 95
    n = 100 / (100 - percentile)

    max_response_time_ms = 100

    results = n.times.map { benchmark_show_call }
    error_message = "Rendering the show page in the #{percentile}th percentile took more than #{max_response_time_ms}ms"
    assert results.sort[-2] < max_response_time_ms, error_message
  end

  private

  def get_show_page
    get :show, params: {phone: @contact.phone}, format: :json
  end

  def benchmark_show_call
    Benchmark.ms do
      get_show_page
      assert_response :success
    end
  end
end
