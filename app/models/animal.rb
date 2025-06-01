class Animal < ApplicationRecord
  has_one :link, as: :ownable
  belongs_to :male, :class_name => 'Animal', :foreign_key => 'animal_id' #for dimorphism
  
  def dimorphic
    male.nil? && Animal.where(animal_id: id).blank?
  end

  def self.weighing mass, set = {}, permitted_variance = 0
    return set if set.keys.length == 3

    match = nil
    permitted_variance = (mass * 0.1).to_i if permitted_variance.zero?
    max_mass = mass + permitted_variance
    target = 5
    while match.blank?
      target += 10
      min_mass = (max_mass * (100 - target)/100).to_i
      match = Animal.where(weight: min_mass...max_mass).order(weight: :desc)
      max_mass = min_mass
    end
    if target > 15
      match = match.last
    else
      match = match.first
    end
    if set[match.name].nil?
      set[match.name] = {count: 1, weight: match.weight}
    else
      set[match.name][:count] += 1
    end
    target = mass - match.weight
    return Animal.weighing(target, set, permitted_variance) if target > permitted_variance * 0.10

    set
  end
  def url
    return male.link unless male.nil?

    link
  end
end
