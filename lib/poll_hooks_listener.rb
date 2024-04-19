class PollsHookListener < Redmine::Hook::ViewListener
  render_on :view_projects_show_left, partial: "polls/project_overview"

  def view_projects_show_left(context = {})
    content_tag("p", "Custom content added to the left")
  end

  def view_projects_show_right(context = {})
    content_tag("p", "Custom content added to the right")
  end
end
