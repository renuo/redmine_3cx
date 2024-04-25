require File.expand_path("../test_helper", __dir__)

class PollsControllerTest < ActionController::TestCase
  fixtures :projects, :groups_users

  def test_index
    get :index, params: {project_id: 1}

    assert_response :success
  end
end
