class DebtUser < ApplicationRecord
  validates_presence_of :name
  validates_uniqueness_of :name
  has_many :debt_operations
end
