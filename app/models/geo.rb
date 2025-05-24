class Geo < ApplicationRecord
    belongs_to :greenspace
    acts_as_taggable_on :amenities
end
