class PagesController < ApplicationController
    def home
        @time_spent = current_user.time_spents.build if signed_in?
    end
end
