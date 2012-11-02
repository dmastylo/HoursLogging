class PagesController < ApplicationController
    def home
        @time_spent = current_user.time_spents.new if user_signed_in?
    end
end
