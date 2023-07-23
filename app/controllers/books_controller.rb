class BooksController < ApplicationController
  def index
    @books = policy_scope(Book)
  end
end
