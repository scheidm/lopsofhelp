class City < Page
  self.table_name = "cities"
  belongs_to :region
  has_many :greenspaces
  has_many :hikes

  def region_code
    return region.short_code
  end
end
