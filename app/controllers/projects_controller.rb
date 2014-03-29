class ProjectsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :user_in_project_or_public, only: [:show]
  before_filter :user_is_creator_of_project, only: [:edit, :update, :destroy]

  def new
    @project = Project.new(privacy_type: Project::PrivacyType::PRIVATE,
                           billable: false)
  end

  def create
    @project = current_user.created_projects.new(project_params)

    if @project.save
      flash[:success] = "Project created."
      redirect_to projects_path
    else
      render 'new'
    end
  end

  def index
    @projects = current_user.projects_sorted_by_recent_work
    @total_time = 0
    @projects.each { |project| @total_time += project.total_time }

    # Prevent divide by 0
    @total_time = 1 if @total_time == 0
  end

  def show
    @time_spents = @project.time_spents.order('created_at DESC').paginate(page: params[:page])
    @users = @project.members

    @total_time = 0
    @users.each { |user| @total_time += user.total_time_of_project(@project) }

    # Prevent divide by 0
    @total_time = 1 if @total_time == 0
  end

  def edit
  end

  def update
    if @project.update_attributes(project_params)
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

  def user_is_creator_of_project
    @project = current_user.created_projects.where(id: params[:project_id] || params[:id]).first

    if @project.blank?
      flash[:error] = "You are not the project admin."
      redirect_to root_path
    end
  end

  def project_params
    params.require(:project).permit(:name, :description, :privacy_type, :billable)
  end

end
