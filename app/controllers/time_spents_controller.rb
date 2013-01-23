class TimeSpentsController < ApplicationController
  include TimeSpentsHelper
  before_filter :authenticate_user!
  before_filter :correct_user, only: [:destroy]

  def index
    @time_spents = TimeSpent.currently_working
  end

  def create
    @time_spent = current_user.time_spents.build(params[:time_spent])
    if @time_spent.save
      flash[:notice] = "Started working!"
      redirect_to root_path
    else
      render 'pages/home'
    end
  end

  def edit
    @time_spent = TimeSpent.find(params[:id])
  end

  # Need to calculate total time as well
  def update
    # editing time spent
    if params[:time_spent][:editing_note]
      @time_spent = TimeSpent.find(params[:id])

      if params[:time_spent][:total_time].to_f < @time_spent.total_time
        if @time_spent.update_attributes( { notes: params[:time_spent][:notes],
                                            finished_at: @time_spent.finished_at - ((@time_spent.total_time - params[:time_spent][:total_time].to_f) * 60).minutes } )
          flash[:success] = "Notes updated!"

          redirect_to project_path(@time_spent.project)
        else
          render "edit"
        end
      else
        flash[:error] = "Total time must be less than previously recorded."
        render "edit"
      end
    else
    # stop timing
      @time_spent = current_user.time_spents.last

      submission_hash = { notes: params[:time_spent][:notes], finished_at: Time.now }
      if @time_spent.update_attributes(submission_hash)
        flash[:notice] = "Done working!"
        redirect_to user_path(current_user)
      else
        flash[:error] = "Please enter what you accomplished." # It really should be the active record error that displays, not this
        redirect_to root_path
      end
    end
  end

  def new

  end

  def import
    @text = params[:csv]
  end

  def destroy
    @time_spent.destroy
    redirect_to :back
  end

private
  def correct_user
    @time_spent = current_user.time_spents.find_by_id(params[:id])
    redirect_to root_path if @time_spent.nil? 
  end
end
