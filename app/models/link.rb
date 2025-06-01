class Link < ApplicationRecord
  belongs_to :ownable, polymorphic: true
  KINDS = %w[]
end
