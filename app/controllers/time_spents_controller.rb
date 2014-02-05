class TimeSpentsController < ApplicationController
  include TimeSpentsHelper

  before_filter :authenticate_user!
  before_filter :correct_user, only: [:edit, :update, :destroy]

  def create
    @time_spent = current_user.time_spents.create(time_spent_params)
    if @time_spent.save
      flash[:notice] = 'Started working!'
      redirect_to root_path
    else
      render 'pages/home'
    end
  end

  def index
    @time_spents = TimeSpent.currently_working
  end

  def edit
    @time_spent = TimeSpent.find(params[:id])
  end

  def update
    @time_spent = TimeSpent.find(params[:id])

    if params[:time_spent][:total_time].to_f <= @time_spent.total_time
      finished_at = @time_spent.finished_at - ((@time_spent.total_time - params[:time_spent][:total_time].to_f) * 60).minutes

      if @time_spent.update_attributes(time_spent_params(finished_at))
        flash[:success] = 'Notes updated!'
        redirect_to project_path(@time_spent.project)
      else
        render 'edit'
      end
    else
      flash[:error] = 'Total time must be less than previously recorded.'
      render 'edit'
    end
  end

  def stop_timing
    @time_spent = current_user.time_spents.last

    if @time_spent.update_attributes(time_spent_params(Time.now))
      flash[:notice] = 'Done working!'
      redirect_to user_path(current_user)
    else
      Rails.logger.info(@time_spent.errors.messages.inspect)
      flash[:error] = 'Please enter what you accomplished.' # It really should be the active record error that displays, not this
      redirect_to root_path
    end
  end

  def destroy
    @time_spent.destroy
    redirect_to :back
  end

  def import
    @text = params[:csv]
  end

private

  def correct_user
    @time_spent = current_user.time_spents.find(params[:id])
    redirect_to root_path if @time_spent.nil? 
  end

  def time_spent_params(finished_at = nil)
    params.require(:time_spent).permit(:notes, :project_id).merge({ finished_at: finished_at })
  end

end
