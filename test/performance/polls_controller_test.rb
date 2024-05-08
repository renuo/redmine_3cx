require File.expand_path("../test_helper", __dir__)
require "benchmark"

class PollsControllerTest < ActionController::TestCase
  fixtures :projects, :members, :users, :groups_users

  def test_index
    test_results = []

    20.times do
      benchmark = Benchmark.ms do
        get :index, params: {project_id: 1}
        assert_response :success
      end

      test_results << benchmark
    end

    assert test_results.sort[-2] < 100, "Rendering the index page in the 95th percentile took more than 100ms"
  end
end
