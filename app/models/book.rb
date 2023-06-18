class Book < ApplicationRecord
  belongs_to :author
  
  validates :title, presence: true
  validates :description, presence: true
  validates :cover_image, presence: true
  validates :year, presence: true
  validates :price, presence: true


end
