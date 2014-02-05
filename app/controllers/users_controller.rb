class UsersController < ApplicationController

  before_filter :authenticate_user!

  def index
    @users = User.all
    @total_time = 0
    @users.each { |user| @total_time += user.total_time }
    @total_time = 1 if @total_time == 0
  end

  def show
    @user = User.find(params[:id])
    @time_spents = @user.time_spents.order('created_at DESC').paginate(page: params[:page])
  end

end