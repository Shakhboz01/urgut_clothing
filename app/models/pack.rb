class Pack < ApplicationRecord
  validates_uniqueness_of :name
end
