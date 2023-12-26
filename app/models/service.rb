class Service < ApplicationRecord
  attr_accessor :price

  belongs_to :user
  validates_presence_of :name
  validates_presence_of :price
  validates_uniqueness_of :name
  enum unit: %i[метр кв кг]

  # TODO: while calculating price give an error if one of unrequired field is null and accaontant is not filled that field manually
end
