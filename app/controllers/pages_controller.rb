class PagesController < ApplicationController
    before_filter :user_signed_in?

    def home
        if user_signed_in?
            @projects = Project.all

            # Initial setup for first project
            @project = Project.new

            if !@projects.last.nil?
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
