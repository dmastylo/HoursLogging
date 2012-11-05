class UsersController < ApplicationController
    before_filter :authenticate_user!
    
    def show
        @user = User.find(params[:id])
        @time_spents = @user.time_spents(page: params[:page])
        @time_spents.delete_if { |time_spent| time_spent.finished_at == nil }
    end
end
