class Admin::DashboardController < ApplicationController
  def index
    @users = User.all
    @number_of_books = Book.count

    @number_of_authors = Author.count

    @authors = Author.all

    @books = Book.all
  end

  def upload
    @url = params[:url]
    BookScraperJob.perform_later(@url)
  end
end
