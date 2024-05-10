require_relative "../test_helper"

class PollTest < ActiveSupport::TestCase
  include FactoryBot::Syntax::Methods

  def test_factory
    @poll = create(:poll)
    assert_equal @poll.valid?, true
  end
end
