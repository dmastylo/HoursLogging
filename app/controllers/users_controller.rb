class UsersController < ApplicationController
    before_filter :authenticate_user!
    
    def show
        @user = User.find(params[:id])
        @time_spents = @user.time_spents.order('finished_at DESC').paginate(page: params[:page])
    end
end