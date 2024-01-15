class Color < ApplicationRecord
  validates_presence_of :name
  validates_presence_of :hex
end
