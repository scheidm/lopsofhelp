class City < Page
  self.table_name = "cities"
  has_many :greenspaces
  has_many :hikes
end
