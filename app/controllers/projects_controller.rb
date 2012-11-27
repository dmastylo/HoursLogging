class ProjectsController < ApplicationController

    def new
        @project = Project.new
    end

    def create
        @project = Project.new(params[:project])
        if @project.save
            flash[:notice] = "Project created."
            redirect_to projects_path
        else
            render 'new'
        end
    end

    def index
        @projects = Project.all
        @total_time = 0
        @projects.each { |project| @total_time += project.total_time }
        @total_time = 1 if @total_time == 0
    end

    def show
        @project = Project.find(params[:id])
        @time_spents = @project.time_spents.order('finished_at DESC').paginate(page: params[:page])
    end
end
