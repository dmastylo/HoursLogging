class PagesController < ApplicationController
  before_filter :signed_in?

  def home
    if signed_in?
      @projects = current_user.projects_sorted_by_recent_work

      # Initial setup for first project
      @project = Project.new

      unless @projects.last.nil?
        @existing_task = current_user.has_running_task?
        @time_spent = current_user.working_time_spent(@existing_task)
      end
    end
  end
end
