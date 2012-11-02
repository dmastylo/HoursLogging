class PagesController < ApplicationController
    def home
        @time_spent = current_user.time_spents.build if user_signed_in?
    end
end
