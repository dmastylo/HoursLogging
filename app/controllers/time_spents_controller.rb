class TimeSpentsController < ApplicationController
    before_filter :authenticate_user!

    def create
        @time_spent = current_user.time_spents.build(params[:time_spent])
        if @time_spent.save
            flash[:notice] = "Time Spent created!"
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
        @totaltime = Time.now - @time_spent.created_at

        submission_hash = { "notes" => params[:time_spent][:notes],
                            "finished_at" => Time.now,
                            "totaltime" => @totaltime}


        if @time_spent.update_attributes(submission_hash)
            flash[:notice] = "Time Spent stopped!"
            redirect_to user_path(current_user)
        else
            render 'pages/home'
        end
    end

    def destroy
        
    end
end
