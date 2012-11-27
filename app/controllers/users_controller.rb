class UsersController < ApplicationController
    before_filter :authenticate_user!
    
    def show
        @user = User.find(params[:id])
        @time_spents = @user.time_spents.where('finished_at NOT NULL').paginate(page: params[:page])
    end
end