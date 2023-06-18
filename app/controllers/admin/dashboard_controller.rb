class Admin::DashboardController < ApplicationController
  def index
    @users = User.all
  end

  def upload
    @url = params[:url]
    BookScraperJob.perform_later(@url)
  end
end
