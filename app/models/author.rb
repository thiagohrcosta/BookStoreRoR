class Author < ApplicationRecord
  has_many :books

  validates :name, presence: true
  validates :about, presence: true
  validates :photo, presence: true
end
