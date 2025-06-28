class Greenspace < Page
  self.table_name = "greenspaces"
  belongs_to :city
  has_many :hikes
  has_many :geos

  def filtered_geos(max_distance_km)
    # Get all geos associated with this greenspace
    all_geos = geos.to_a
    
    # Find the geo with a street address to use as reference point
    reference_geo = all_geos.find { |geo| geo.street_address.present? }
    
    return [] if reference_geo.nil?
    
    # Filter geos based on distance from reference geo
    all_geos.select do |geo|
      distance = Geo.calculate_distance(
        lat1: reference_geo.lat,
        lon1: reference_geo.lon,
        lat2: geo.lat,
        lon2: geo.lon
      )
      distance <= max_distance_km
    end
  end

end
