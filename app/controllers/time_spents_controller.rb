class TimeSpentsController < ApplicationController
    before_filter :signed_in_user

    def new
        @time_spent = current_user.time_spents.build(params[:time_spent])
        if @time_spent.save
            flash[:success] = "Micropost created!"
            redirect_to root_url
        else
            render 'pages/home'
        end
    end

    def create
        
    end

    def destroy
        
    end
end
