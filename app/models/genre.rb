class Genre < ApplicationRecord
  has_many :authors
  has_many :books, through: :authors
end
