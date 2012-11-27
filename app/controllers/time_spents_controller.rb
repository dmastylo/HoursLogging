class TimeSpentsController < ApplicationController
    include TimeSpentsHelper
    before_filter :authenticate_user!

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
        
    end

    # Need to calculate total time as well
    def update
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

    def new

    end

    def import
        @text = params[:csv]
    end

    def destroy
    end
end
