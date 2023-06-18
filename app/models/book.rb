class Book < ApplicationRecord
  belongs_to :author
  
  has_many :book_genres
  has_many :genres, through: :book_genres

  validates :title, presence: true
  validates :description, presence: true
  validates :cover_image, presence: true
  validates :year, presence: true
  validates :price, presence: true
end
