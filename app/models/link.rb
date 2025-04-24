class Link < ApplicationRecord
  belongs_to :ownable, polymorphic: true
end
