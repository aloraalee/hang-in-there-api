class Poster < ApplicationRecord
    validates :name, presence: true, uniqueness: true
    validates :description, presence: true
    validates :price, presence: true, numericality: { only_float: true }
    validates :year, presence: true, numericality: { only_integer: true }
    validates :vintage, inclusion: { in: [true, false], message: "must be true or false" }
  
end