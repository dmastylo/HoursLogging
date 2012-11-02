class TimeSpentsController < ApplicationController
    before_filter :current_user

    def new
        
    end

    def create
        @time_spent = current_user.time_spents.build(params[:time_spent])
        if @time_spent.save
            flash[:notice] = "Time Spent created!"
            redirect_to user_path(current_user)
        else
            render 'pages/home'
        end
    end

    def destroy
        
    end
end
