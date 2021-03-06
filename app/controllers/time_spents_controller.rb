class TimeSpentsController < ApplicationController
  include TimeSpentsHelper

  before_filter :authenticate_user!
  before_filter :user_owns_time_spent, only: [:edit, :update, :destroy]
  before_filter :user_not_working, only: [:create]
  before_filter :time_spent_ids_present, only: [:mark_as_paid]

  def create
    @time_spent = current_user.time_spents.create(time_spent_params)
    @time_spent.set_amount_paid

    if @time_spent.save
      flash[:notice] = 'Started working!'
      redirect_to root_path
    else
      flash[:error] = "You can't work for a project you're not a part of." # It really should be the active record error that displays, not this
      redirect_to root_path
    end
  end

  def index
    @time_spents = TimeSpent.currently_working
  end

  def edit
  end

  def update
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

  def destroy
    @time_spent.destroy
    flash[:success] = 'Deleted Work Time!'
    redirect_to :back
  end

  def import
    @text = params[:csv]
  end

  def stop_timing
    @time_spent = current_user.time_spents.last

    if @time_spent.update_attributes(time_spent_params(Time.now))
      flash[:success] = 'Done working!'
      redirect_to user_path(current_user)
    else
      Rails.logger.info(@time_spent.errors.messages.inspect)
      flash[:error] = 'Please enter what you accomplished.' # It really should be the active record error that displays, not this
      redirect_to root_path
    end
  end

  def mark_as_paid
    # Only allow time_spents owned by the user to be modified
    # & operator merges two arrays and keeps only elements that are NOT unique
    params[:time_spent_ids] = params[:time_spent_ids].map(&:to_i) & current_user.time_spents.pluck(:id)

    # Single SQL statement, skips validations and callbacks
    TimeSpent.where(id: params[:time_spent_ids]).update_all(paid_status: true)

    redirect_to :back
  end

private

  def user_owns_time_spent
    @time_spent = current_user.time_spents.where(id: params[:time_spent_id] || params[:id]).first

    if @time_spent.blank?
      flash[:error] = "That's not your time spent."
      redirect_to root_path
    end
  end

  def user_not_working
    if current_user.currently_working?
      flash[:error] = "You are already working!"
      redirect_to root_path
    end
  end

  def time_spent_ids_present
    if params[:time_spent_ids].blank?
      flash[:error] = 'No logs selected.'
      redirect_to :back
    end
  end

  def time_spent_params(finished_at = nil)
    params.require(:time_spent).permit(:notes, :project_id, :paid_status,:amount_paid)
                               .merge( { finished_at: finished_at } )
  end

end
