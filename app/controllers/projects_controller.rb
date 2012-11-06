class ProjectsController < ApplicationController
    def create
        @project = Project.new(params[:project])
        if @project.save
            flash[:notice] = "Project Created"
            redirect_to root_path
        else
            render 'pages/home'
        end
    end

    def index
        @projects = Project.all
    end

    def show
        @project = Project.find(params[:id])
        @time_spents = @project.time_spents(page: params[:page])
        @time_spents.delete_if { |time_spent| time_spent.finished_at == nil }
    end
end
