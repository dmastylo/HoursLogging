class ApplicationController < ActionController::Base

  protect_from_forgery

protected

  def user_in_project_or_public
    @project = Project.find(params[:project_id] || params[:id])

    if @project.private? && !@project.members.include?(current_user)
      flash[:error] = "You are not a part of that project."
      redirect_to root_path
    end
  end

end
