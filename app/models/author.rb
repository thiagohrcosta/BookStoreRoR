class Author < ApplicationRecord
  has_many :books
  has_many :author_genres
  has_many :genres, through: :author_genres

  validates :name, presence: true
  validates :about, presence: true
  validates :photo, presence: true
end
