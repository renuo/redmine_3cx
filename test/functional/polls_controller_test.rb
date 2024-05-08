require File.expand_path("../test_helper", __dir__)

class PollsControllerTest < ActionController::TestCase
  fixtures :projects, :members, :users, :groups_users

  def test_index
    get :index, params: {project_id: 1}

    assert_response :success
  end

  def test_index_performance
    test_results = 20.times.map { benchmark_index_call }
    error_message = "Rendering the index page in the 95th percentile took more than 100ms"
    assert test_results.sort[-2] < 100, error_message
  end

  private

  def benchmark_index_call
    Benchmark.ms do
      get :index, params: {project_id: 1}
      assert_response :success
    end
  end
end
