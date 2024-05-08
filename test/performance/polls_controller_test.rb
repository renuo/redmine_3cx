require File.expand_path("../test_helper", __dir__)
require "benchmark"

class PollsControllerTest < ActionController::TestCase
  fixtures :projects, :members, :users, :groups_users

  def test_index
    20.times do
      benchmark = Benchmark.ms do
        get :index, params: {project_id: 1}
        assert_response :success
      end

      puts "Rendering the index page took #{benchmark}ms"

      assert benchmark < 1000, "Rendering the index page took more than 1000ms"
    end
  end
end
