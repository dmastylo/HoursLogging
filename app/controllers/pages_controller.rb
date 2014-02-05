class PagesController < ApplicationController
  before_filter :signed_in?

  def home
    if signed_in?
      @projects = Project.sorted_by_recent_work

      # Initial setup for first project
      @project = Project.new

      unless @projects.last.nil?
        @existing_task = current_user.has_running_task?

        if @existing_task
          @time_spent = current_user.time_spents.last
        else
          @time_spent = current_user.time_spents.build
        end
      end
    end
  end
end
