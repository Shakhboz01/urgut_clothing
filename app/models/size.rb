class Size < ApplicationRecord
  validates_uniqueness_of :name
  before_validation :strip_whitespace

  private

  def strip_whitespace
    self.name = name.strip.split.join.downcase
  end
end
