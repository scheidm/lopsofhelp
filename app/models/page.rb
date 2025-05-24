class Page < ApplicationRecord
  extend FriendlyId
  friendly_id :name

  def self.convert_weight weight
    weight * 2.20462 / 1000
  end

  def self.distance_formula
  end
end
