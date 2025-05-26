class Greenspace < Page
  self.table_name = "greenspaces"
  belongs_to :city
  has_many :hikes
  has_many :geos

end
