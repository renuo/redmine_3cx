class PollsController < ApplicationController
  before_action :find_project, :authorize, only: [:index, :vote]

  def index
    @polls = Poll.all
  end

  private

  def find_project
    @project = Project.find(params[:project_id])
  end
end
