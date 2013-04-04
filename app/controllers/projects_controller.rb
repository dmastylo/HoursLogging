class ProjectsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :project, only: [:show, :destroy, :edit, :update]
  
  def index
    @projects = Project.sorted_by_recent_work
    @total_time = 0
    @projects.each { |project| @total_time += project.total_time }
    @total_time = 1 if @total_time == 0
  end

  def show
    @time_spents = @project.time_spents.order('created_at DESC').paginate(page: params[:page])
    @users = User.project_users(@project.id)

    @total_time = 0
    @users.each { |user| @total_time += user.total_time_of_project(@project.id) }
    @total_time = 1 if @total_time == 0
  end

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

  def edit
  end

  def update
    if @project.update_attributes(params[:project])
      flash[:success] = "Project updated!"
      redirect_to project_path(@project)
    else
      render "edit"
    end
  end

  def destroy
    @project.destroy
    flash[:success] = "Project deleted!"
    redirect_to projects_path
  end

private
  def project
    @project = Project.find(params[:id])
    redirect_to root_path if @project.nil? 
  end
end
